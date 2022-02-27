function [edge_nodL,mat_B,mat_edge_B]=cal_kk_NSFEM_T4_T_nonlinear(nel,neigh,nodes,gcoord,vol_tetra,nnel,vol_edge)     

nedge=size(neigh,1);
mat_B=cell(nel,1);
edge_nodL=cell(nedge,1);
mat_edge_B=cell(nedge,1);

for iel=1:nel           % loop for the total number of elements         
    x=0;y=0;z=0;
    for i=1:nnel
        nd(i)=nodes(iel,i);         % extract connected node for (iel)-th element
        xcoord(i,1)=gcoord(nd(i),1);  % extract x value of the node
        ycoord(i,1)=gcoord(nd(i),2);  % extract y value of the node
        zcoord(i,1)=gcoord(nd(i),3);  % extract z value of the node
        x=x+1/3*xcoord(i,1);
        y=y+1/3*ycoord(i,1);
        z=z+1/3*zcoord(i,1);
    end     
    [~,dhdx,dhdy,dhdz,~]=federiv3_T4(x,y,z,xcoord,ycoord,zcoord); % compute element matrix
    Bmat=fekine3d_T(nnel,dhdx,dhdy,dhdz);          % compute kinematic matrix        
    mat_B{iel}=Bmat;    
end

for ied = 1:nedge                                     
    [nodL,BL] = formBmat_NSFEM_T4_T(neigh{ied},nodes,vol_edge(ied),vol_tetra,mat_B);
                   % element stiffness matrice    
    edge_nodL{ied}=nodL;
    mat_edge_B{ied}=BL;
    
    clear BL nodL 
end  