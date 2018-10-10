function next_gen_matrix_R0
% compute the inverse of the Jacobian of V and the Next Gen Matrix
% for the WNV model 
%  July 21, 2015, Mac 
clear
% notation simplificaitons: 
% di = d_if*delta_i, cbi = c_i*beta_i, cbh=c_h*beta_h, cbf=c_f*beta_f

syms tau_h tau_v nu_v mu_v alpha_h1 alpha_h2 alpha_v1 alpha_v2

% one bird model
J_v = [1/tau_h 0 0 0; 
       0 1/tau_h 0 0;
       0 0 1/tau_v 0; 
       0 0 -nu_v mu_v]

 J_v_inv = inv(J_v)
 

J_F =  [ 0 0 0 alpha_h1 ; 
         0 0 0 alpha_h2; 
         alpha_v1 alpha_v2 0 0; 
         0 0 0 0]

N = J_F*J_v_inv
N_ev = eig(N)

% % double check
% R0_v = bb_bv*nu_v*tau_ev*tau_iv
% R0_b = bb_vb*nu_b*tau_eb*tau_ib
% R0=sqrt(R0_v*R0_b)
% N_ev(3)
% error = N_ev(3)-R0
% 
% % two bird model SIR-SIR^2
% 
% % p_iv = nu_v*tau_ev ;
% % p_ib = nu_b*tau_eb ;
% % p_im = nu_m*tau_em ;
% 
% %therefor
% nu_v = p_iv/tau_ev;
% nu_b = p_ib/tau_eb ;
% nu_m = p_im/tau_em ;
% 
% 
% % J_v = [1/tau_ev 0 0 0; 
% %     -nu_v 1/tau_iv 0 0;
% %     0 0 1/tau_ib 0 ; 
% %       0 0  0  -nu_m 1/tau_im]
% 
% % convert this to just use the probabilty of entering a state
% J_v = [1/tau_ev 0 0 0; 
%     -p_iv/tau_ev 1/tau_iv 0 0;
%     0 0 1/tau_ib 0 ; 
%       0 0  0  1/tau_im]
% 
% 
%  J_v_inv = inv(J_v)
%  
% 
% J_F =  [ 0 0  bb_vb  bb_vm; 
%          0 0 0 0  ; 
%          0 bb_bv 0 0  ; 
%          0 bb_mv 0 0  ;]
% 
% N = J_F*J_v_inv
% N_ev = eig(N)
% 
% % % two bird model SIR-SEIR^2
% % 
% % % p_iv = nu_v*tau_ev ;
% % % p_ib = nu_b*tau_eb ;
% % % p_im = nu_m*tau_em ;
% % 
% % %therefor
% % nu_v = p_iv/tau_ev;
% % nu_b = p_ib/tau_eb ;
% % nu_m = p_im/tau_em ;
% % 
% % 
% % % J_v = [1/tau_ev 0 0 0 0 0; 
% % %     -nu_v 1/tau_iv 0 0 0 0;
% % %     0 0 1/tau_eb 0 0 0; 
% % %      0 0 -nu_b 1/tau_ib 0 0;
% % %      0 0 0  0 1/tau_em 0;
% % %       0 0  0 0 -nu_m 1/tau_im]
% % 
% % % convert this to just use the probabilty of entering a state
% %   J_v = [1/tau_ev 0 0 0 0 0; 
% %     -p_iv/tau_ev 1/tau_iv 0 0 0 0;
% %     0 0 1/tau_eb 0 0 0; 
% %      0 0 -p_ib/tau_eb 1/tau_ib 0 0;
% %      0 0 0  0 1/tau_em 0;
% %       0 0  0 0 -p_im/tau_em 1/tau_im]
% % 
% %   
% % 
% %  J_v_inv = inv(J_v)
% %  
% % 
% % J_F =  [ 0 0 0 bb_vb 0 bb_vm; 
% %          0 0 0 0 0 0; 
% %          0 bb_bv 0 0 0 0; 
% %          0 0 0 0 0 0; 
% %          0 bb_mv 0 0 0 0;
% %          0 0 0 0 0 0; ]
% % 
% % N = J_F*J_v_inv
% % N_ev = eig(N)
% % 
% % 
% % subs(N_ev, nu_v*tau_ev, p_iv)
% % 
% % % N_ev = simplify(N_ev)
end

