function m_opts= m_settings(paths)
    
 
    iTestSample_Start= 1; startfrom = 1;  show_output = 0; 
    m_mode = 'training' ; %'training' , 'test'
    proj = 'vt'; %'vt-rgb'
    f_dimension = 4096;% '512' or '4096'
    pre_net = 'vd16';% 'vd16', 'caffe'
    net_dataset = 'pitts30k'; % tokyoTM', 'pitts30k' 
    job_net = strcat(pre_net,'_',net_dataset); 
    job_datasets = 'pitts30k-vt';  %'tokyo247' 'tokyo247-vt-3', 'pitts30k' 'oxford' , 'tokyo247-vt', 'paris-vt-rgb', 'pitts30k-vt
    m_on = 'paris'; % m model using Paris dataset. 'ox5k' or 'paris'
    m_directory = '/home/leo/mega/maqbool-data/';
    %%
    
    
    
    if strcmp(job_net,'vd16_pitts30k')
        % PITTSBURGH DATASET
       netID= 'vd16_pitts30k_conv5_3_vlad_preL2_intra_white';

    elseif strcmp(job_net,'vd16_tokyoTM')
        % TOKYO DATASET
        netID= 'vd16_tokyoTM_conv5_3_vlad_preL2_intra_white';
    end

    if strcmp(job_datasets,'pitts30k')
        dbTest= dbPitts('30k','test');
        datasets_path = paths.dsetRootPitts;
        query_folder = 'queries';

    elseif strcmp(job_datasets,'tokyo247-vt')
        dbTest= dbTokyo247();
        datasets_path = paths.dsetRootTokyo247; %% PC
        datasets_box_path = '/home/leo/docker_ws/datasets/Test_247_Tokyo_GSV/view-tags/Test_247_Tokyo_GSV_1_e_boxes'; 
        query_folder = 'query';

    elseif strcmp(job_datasets,'pitts30k-vt')
        dbTest= dbPitts('30k','test');
        datasets_path = '/home/leo/docker_ws/datasets/Pittsburgh_Viewtag_1_e'; %% PC
        datasets_box_path = '/home/leo/docker_ws/datasets/Pittsburgh_Viewtag_1_e'; %% PC

        query_folder = 'queries';    
        
    elseif strcmp(job_datasets,'tokyo247')
        dbTest= dbTokyo247();
        datasets_path = paths.dsetRootTokyo247; 
        query_folder = 'query';

    elseif strcmp(job_datasets,'paris')
        dbTest= dbVGG('paris');
        datasets_path = paths.dsetRootParis; %% PC
        query_folder = 'images';                
        
    elseif strcmp(job_datasets,'oxford')
        dbTest= dbVGG('ox5k');
        datasets_path = paths.dsetRootOxford; %% PC
        query_folder = 'images';

    elseif strcmp(job_datasets,'paris-vt-rgb')
        dbTest= dbVGG('paris');
        datasets_path = paths.dsetRootHolidays; %% PC
        query_folder = 'images';
    end

    
    save_path = strcat(m_directory,job_net,'_to_',job_datasets,'_',int2str(f_dimension),'_',proj);
    save_m_data = strcat(m_directory,'models/',job_net,'_to_',m_on,'_',int2str(f_dimension),'_data.mat');
    save_m_data_mdl = strcat(m_directory,'models/', job_net,'_to_',m_on,'_',int2str(f_dimension),'_mdls.mat');

    save_path_all = strcat(m_directory,job_net,'_to_',job_datasets,'_box_50_plus','.mat');
        
    % Save result for tikz latex
    m_d_results_fname = strcat('results/',job_net,'_to_',job_datasets,'_maqbool_D_',int2str(f_dimension),'.dat');
    m_r_results_fname = strcat('results/',job_net,'_to_',job_datasets,'_maqbool_R_',int2str(f_dimension),'.dat');
    netvlad_results_fname = strcat('results/',job_net,'_to_',job_datasets,'_netvlad_',int2str(f_dimension),'.dat');
    save_results = strcat('results/',job_net,'_to_',job_datasets,'_both_results_',int2str(f_dimension),'.mat');
    
    %%
    m_opts = struct(...
                'm_directory',              m_directory, ...
                'netID',                    netID, ...
                'proj',                     proj, ...
                'job_net',                  job_net, ...
                'datasets_path',            datasets_path, ...
                'datasets_box_path',        datasets_box_path, ...
                'save_path',                save_path, ...
                'save_results',             save_results, ...
                'save_path_all',            save_path_all, ...
                'save_m_data',              save_m_data, ...
                'save_m_data_mdl',          save_m_data_mdl, ...
                'm_d_results_fname',        m_d_results_fname, ...
                'm_r_results_fname',        m_r_results_fname, ...
                'netvlad_results_fname',    netvlad_results_fname, ...
                'vt_type',                  3, ...
                'iTestSample_Start',        iTestSample_Start, ...
                'startfrom',                startfrom, ...
                'show_output',              show_output, ...
                'query_folder',             query_folder, ...
                'dbTest',                   dbTest, ...
                'cropToDim',                f_dimension, ...
                'm_on',                     m_on, ....    
                'create_Model',             0 ...
                );


end
