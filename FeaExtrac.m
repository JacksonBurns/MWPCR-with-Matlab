classzero=data_train(1:60,:)'*SVD{1,1}(1:60,:);
classone=data_train(61:100,:)'*SVD{1,1}(61:100,:);
zero1=reshape(classzero(:,1),20,20,10);
one1=reshape(classone(:,1),20,20,10);
figure(1);
imshow((zero1(:,:,5)-min(min(zero1(:,:,5))))./max(max(abs(zero1(:,:,5)))));
j=[postion(1:2,1:400)',reshape(zero1(:,:,5),[],1)];
plot(j(:,1),j(:,2),'.')
imshow(one1(:,:,5),[min(min(one1(:,:,5))) max(max(one1(:,:,5)))]);
figure(2);
imshow((one1(:,:,5)-min(min(one1(:,:,5))))./max(max(abs(one1(:,:,5)))));
imshow(reshape(esp_long_train(1,1601:2000),20,20))
imshow(reshape(esp_long_train(100,1601:2000),20,20))