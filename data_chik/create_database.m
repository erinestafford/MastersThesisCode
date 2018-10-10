function database=create_database()
% Output data is a structure.  Structure entries are arrays.
% The meat of the database are the PAHO arrays.  Entries are an cell array
% countries   : Cell array of unique country names
% population  : Numerical array of population per country
% PAHO        : Direct copy of the data from the PAHO pdfs
% PAHO_linear : For stretches of identical data, we linearly interp between the low and high points
% PAHO_sparse : Only expose the low and high points; sparse in X

% The names of countries may include accents and cedillas, MATLAB doesn't like those by default.
feature('DefaultCharacterSet','UTF-8');

fname = 'Chik_Week_3.csv';

assert(exist(fname,'file')==2, 'File ''%s'' not found.', fname)

% This should be the header line of the file that is read in.
%id,COUNTRY,YEAR,WEEK,Week.Sus.Cases,Incidence.sus.cases,Cum.sus.cases,Week.conf.cases,Incidence.conf.cases,Cum.conf.cases,Week.import.cases,Cum.import.cases,Week.deaths,Cum.deaths,Population,Source
isnum=[1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 0];
fieldname = {'id','country','year','week','wsc','isc','csc','wcc','icc','ccc','wic','cic','wd','cd','pop','src'};

% Read UTF-8 file
fid=fopen(fname,'r','n','UTF-8');
txt=fread(fid,'*char')';

% Read raw text as csv and convert to cell array using csv2cell function found on Matlab's website.
converted=csv2cell(txt);

clear('data','var');

% Gather data, keeping strings as strings, and casting numbers into a numerical format.
[npts,ncol]=size(converted);
assert(length(fieldname) == ncol,'Data file differs from expected input')
for i = npts:-1:1
    for j = 1:ncol
        datum = converted{i,j};
        if isnum(j) == 1
            data.(fieldname{j})(i) = str2double(datum);
        else
            data.(fieldname{j}){i} = datum;
        end
    end
end

% Walk every record and tally up all the country names we see.
% Assert that the country population doesn't change, for now.
countries = {};
clen = 0;
for i = 2:npts % 2: ignores the header
    % Grab the country name
    cname = data.country{i};

    % Hunt for the country name in our cell array, add if not there
    js = find(strcmp(cname, countries),1);
    if isempty(js)
        clen = clen + 1;
        countries{clen} = cname;
        database(clen).name = cname;
        database(clen).population = data.pop(i);
    else
        assert(strcmp(database(js).name,cname)); 
        assert(database(js).population == data.pop(i));
    end
end


% Walk through the csv data again, for each point of Tycho data add up the number of cases, and store it
PAHO = NaN(clen,32); % ncols is nweeks, we can estimate low as MATLAB will auto-increase data structure bounds.
PAHO_confirmed = NaN(clen,32); % ncols is nweeks, we can estimate low as MATLAB will auto-increase data structure bounds.
for i = 2:npts % ignore the first line
    year = (data.year(i) - 2014);
    if year < 0 % Ignore 2013 data
        continue
    end
    week = data.week(i) + year * 52;

    % Hunt for the country, for each point in the list (this is very slow)
    j = find(strcmp(data.country{i}, countries),1);

    % Cumulative and Suspected cases, we ignore imported cases
    PAHO(j,week) = data.ccc(i) + data.csc(i);
    PAHO_confirmed(j,week) = data.ccc(i);
end

% Now, for each country, for each point of data,
% linearly interpolate, and sparsify by remove duplicates.
PAHO_linear = NaN(size(PAHO));
PAHO_sparse = zeros(size(PAHO));
for i = 1:size(PAHO,1)
    pdata = PAHO(i,:);
    last = [1, pdata(1)]; % index, value
    PAHO_linear(i,1) = pdata(1);
    PAHO_sparse(i,1) = pdata(1);
    for j = 2:length(pdata)
        if last(2) < pdata(j)
            PAHO_sparse(i,j) = pdata(j);

            xin = last(1):j;
            yin = interp1([last(1) j],[last(2) pdata(j)],xin);
            PAHO_linear(i,xin) = yin;

            last(1) = j;
            last(2) = pdata(j);
        end
    end
    if last(1) ~= size(PAHO,2)
        xin = (last(1)+1):size(PAHO,2);
        PAHO_linear(i,xin) = last(2);
    end
    
end

% Augment the database with the counts
for i = 1:clen
    database(i).count = PAHO(i,:);
    database(i).count_linear = PAHO_linear(i,:);
    database(i).count_sparse = PAHO_sparse(i,:);
    database(i).count_confirmed = PAHO_confirmed(i,:);
    I = find(PAHO_sparse(i,:) > 0, 1);
    database(i).first_week = I;
    database(i).first_count = database(i).count_sparse(I);
end

end
