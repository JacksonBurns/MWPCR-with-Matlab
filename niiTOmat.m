% 将主目录极其子目录下的所有.nii文件转换为向量储存的mat文件.
cd E:\mypackages\MWPCR-with-Matlab;
allpath=search_nii({},'E:\Image\ABIDE2');

imgfile=cell(size(allpath,1),1);
for index=1:size(allpath,1)
    try
        imgfile(index,1)={load_nii(allpath{index,1})};
    catch
        fprintf('%d\n',index);
    end
end
siz=size(imgfile{1}.img);
% for index=1:size(allpath,1)
%     if sum(size(imgfile{index}.img)-siz)~=0
%         fprintf('%d\n',index);
%     end
% end

img=zeros(size(imgfile,1),prod(siz));
for index=1:size(imgfile,1)
    img(index,:)=reshape(imgfile{index}.img,1,[]);
end
% img=imgfile{1}.img;
% img=img(100:103,89:90,23:25);
% imshow(reshape(img(100,:,:),256,256),[0,255])
% imshow(img(:,:,120),[0,255])
% imshow(reshape(img(1,100*176*256+1:101*176*256),176,256),[0 255])
% imshow(imgfile{1}.img(:,:,100),[0 255])
