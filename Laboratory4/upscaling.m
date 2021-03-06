function upscaling(image, factor_row, factor_column)

img = imread(image);
[rows, columns, depth] = size(img);

new_rows = round(rows * factor_row);
new_columns = round(columns * factor_column);

add_rows = round((new_rows - rows) / 2) ;
add_columns = round((new_columns - columns) / 2);

if (depth == 1)
    
    figure;
    subplot(2, 3, 1)
    imshow(img)
    title(['Original Image, size ', num2str(rows), 'x', num2str(columns)]);
    
    img_ft = fft2(img);
    subplot(2, 3, 2)
    imshow(log(abs(img_ft)), [3, 10]);
    title('Spectrum');

    img_ft_shifted = fftshift(img_ft);
    subplot(2, 3, 3)
    imshow(log(abs(img_ft_shifted)), [3, 10]);
    title('Shifted Spectrum');
    
    padded_img_ft_shifted = padarray(img_ft_shifted, [add_rows, add_columns]);
    subplot(2, 3, 4)
    imshow(log(abs(padded_img_ft_shifted)), [3, 10]);
    title('Shifted Spectrum Upscaled');

    padded_img_ft_unshifted = fftshift(padded_img_ft_shifted);
    subplot(2, 3, 5)
    imshow(log(abs(padded_img_ft_unshifted)), [3, 10]);
    title('Unshifted Spectrum Upscaled');

    padded_img_ft_unshifted_inverse = ifft2(padded_img_ft_unshifted * factor_row * factor_column);
    [rows_final, columns_final, depth_final] = size(padded_img_ft_unshifted_inverse);
    subplot(2, 3, 6)
    imshow(uint8(padded_img_ft_unshifted_inverse));
    title(['Upscaled image, factor ', num2str(factor_row), 'x', num2str(factor_column), ', size ', num2str(rows_final), 'x', num2str(columns_final)]);
    
    imwrite(uint8(padded_img_ft_unshifted_inverse), 'upscaled_image_gray.jpg')
    imwrite(uint8(img), 'image_gray.jpg')
end
    
if (depth == 3)
    
    figure;
    subplot(1, 2, 1)
    imshow(img);
    title(['Original Image, size ', num2str(rows), 'x', num2str(columns)]);
    
    redChannel = img(:,:,1); 
    greenChannel = img(:,:,2); 
    blueChannel = img(:,:,3); 
    
    img_ft_red = fft2(redChannel);
    img_ft_green = fft2(greenChannel);
    img_ft_blue = fft2(blueChannel);

    img_ft_shifted_red = fftshift(img_ft_red);
    img_ft_shifted_green = fftshift(img_ft_green);
    img_ft_shifted_blue = fftshift(img_ft_blue);

    padded_img_ft_shifted_red = padarray(img_ft_shifted_red, [add_rows, add_columns]);
    padded_img_ft_shifted_green = padarray(img_ft_shifted_green, [add_rows, add_columns]);
    padded_img_ft_shifted_blue = padarray(img_ft_shifted_blue, [add_rows, add_columns]);

    padded_img_ft_unshifted_red = fftshift(padded_img_ft_shifted_red);
    padded_img_ft_unshifted_green = fftshift(padded_img_ft_shifted_green);
    padded_img_ft_unshifted_blue = fftshift(padded_img_ft_shifted_blue);    
    
    padded_img_ft_unshifted_inverse_red = ifft2(padded_img_ft_unshifted_red * factor_row * factor_column);
    padded_img_ft_unshifted_inverse_green = ifft2(padded_img_ft_unshifted_green * factor_row * factor_column);
    padded_img_ft_unshifted_inverse_blue = ifft2(padded_img_ft_unshifted_blue * factor_row * factor_column);  
    
    recombinedImage = cat(3, padded_img_ft_unshifted_inverse_red, padded_img_ft_unshifted_inverse_green, padded_img_ft_unshifted_inverse_blue);
    [rows_final, columns_final, depth_final] = size(recombinedImage);
    subplot(1, 2, 2)
    imshow(uint8(recombinedImage));
    title(['Upscaled image, factor ', num2str(factor_row), 'x', num2str(factor_column), ', size ', num2str(rows_final), 'x', num2str(columns_final)]);
    
    imwrite(uint8(recombinedImage), 'upscaled_image_rbg.jpg')
    imwrite(uint8(img), 'image_rbg.jpg')
    
end

end