function q_feat = m_edge_box_features(qimg_path, datasets_box_path, model, db,q_feat,net,num_box,total_top,dataset_path,ids,iTestSample,m_config)

im= vl_imreadjpeg({char(qimg_path)},'numThreads', 12); 

I = uint8(im{1,1});
%[bbox_all, ~] =edgeBoxes(I,model);
qimg_path = strcat(datasets_box_path, '/',m_config.query_folder, '/', db.qImageFns{iTestSample, 1});  

q_edge_box_path = strrep(qimg_path,'.jpg','.mat');

load(q_edge_box_path);
% [bbox,im, E, hyt, wyd] = img_Bbox(qimg_path,model);
[hyt, wyd, ~] = size(im{1,1});

mat_boxes = m_increase_boxes(bboxes,hyt,wyd);
clear bboxes;
im= im{1}; % slightly convoluted because we need the full image path for `vl_imreadjpeg`, while `imread` is not appropriate - see `help computeRepresentation`
query_full_feat= m_computeRepresentation(net, im, mat_boxes,num_box); % add `'useGPU', false` if you want to use the CPU

db_bbox_top = [1 1 wyd hyt 1];
q_bbox = [db_bbox_top ; double(mat_boxes)*16];
q_bbox = q_bbox (1:num_box+1,:);


k = num_box;


% Top 100 sample

for jj = 1:size(ids,1)

        ds_all_full = [];
%         ids_all = [];

        db_img = strcat(dataset_path,'images/', db.dbImageFns{ids(jj,1),1})  ;
        im= vl_imreadjpeg({char(db_img)},'numThreads', 12); 
        I = uint8(im{1,1});
        dbimg_path = strcat(datasets_box_path, '/','images/', db.dbImageFns{ids(jj,1),1})  ;  
        db_edge_box_path = strrep(dbimg_path,'.jpg','.mat');
        load(db_edge_box_path);

        [hyt, wyd, ~] = size(im{1,1});   % update the size accordign to the DB images. as images have different sizes. 

        mat_boxes = m_increase_boxes(bboxes,hyt,wyd);

        im= im{1}; % slightly convoluted because we need the full image path for `vl_imreadjpeg`, while `imread` is not appropriate - see `help computeRepresentation`
        feats= m_computeRepresentation(net, im, mat_boxes,num_box); % add `'useGPU', false` if you want to use the CPU
        db_bbox_top = [1 1 wyd hyt 1];
        db_bbox = [db_bbox_top ; double(mat_boxes)*16];
        db_bbox = db_bbox (1:num_box+1,:);

        db_bbox_file(jj) = struct ('bboxdb', db_bbox); 

        fprintf( '==>> %i ~ %i/%i ',iTestSample,jj,total_top );


        for j = 1:num_box+1
            q1 = single(feats(:,j));  %take column of each box
            ds1= m_yael_nn(query_full_feat, q1, k);

            ds_all_full = [ds_all_full ds1'];
        end

        clear feats;
        ds_all_file(jj) = struct ('ds_all_full', ds_all_full); 


end

  % save the files
check_folder = fileparts(q_feat);
if ~exist(check_folder, 'dir')
    mkdir(check_folder)
end
 save(q_feat,'ds_all_file', 'q_bbox', 'db_bbox_file');
 clear ds_all_file;

end