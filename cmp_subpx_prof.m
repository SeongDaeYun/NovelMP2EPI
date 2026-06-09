
% ========================================================================
% * Function: h1 = cmp_subpx_prof( mp2rage_i, mp2epiu_i, mp2epic_i, n_lines, n_sample )
%             - draw sub-pixel line profiles
%
% * Input : 
%           --------------------------------------------------------------
%                        |               Description
%           --------------------------------------------------------------
%           mp2rage_i    | MP2RAGE image (2D) (*.nii)
%           mp2epiu_i    | MP2EPI-uncorrected image (2D) (*.nii)
%           mp2epic_i    | MP2EPI-corrected image (2D) (*.nii)
%           n_lines      | number of lines
%           n_sample     | number of samples per line
%           --------------------------------------------------------------
%
% * Output : 
%           --------------------------------------------------------------
%                        |               Description
%           --------------------------------------------------------------
%           hi           | figure handle
%           --------------------------------------------------------------
%
% * dev.: Seong Dae Yun (s.yun@fz-juelich.de)
% ========================================================================


function hi = cmp_subpx_prof( mp2rage_i, mp2epiu_i, mp2epic_i, n_lines, n_sample )


% Get coordinates
hi = figure ;
imshow( mp2rage_i, [0 max( mp2rage_i(:) )*0.75] )
[x_input, y_input] = ginput(2);

% Get profiles
del_xy = 0.05 ;
prof_mp2rage = zeros( n_sample, n_lines ) ;
prof_mp2epiu = zeros( n_sample, n_lines ) ;
prof_mp2epic = zeros( n_sample, n_lines ) ;
for ii = 1 : 1 : n_lines 

    x_coords = x_input - floor( n_lines/2 )*del_xy + (ii-1)*del_xy ;
    y_coords = y_input - floor( n_lines/2 )*del_xy + (ii-1)*del_xy ;
    
    h1 = drawpolyline( gca, 'Position', [x_coords y_coords], 'Color', [1.0 1.0 0.0], 'LineWidth', 4 ) ;
    h1.MarkerSize = 0.01 ;
    h1.InteractionsAllowed = 'none' ;

    prof_mp2rage( :, ii ) = improfile( mp2rage_i, x_coords, y_coords, n_sample, 'bicubic' ) ; 
    prof_mp2epiu( :, ii ) = improfile( mp2epiu_i, x_coords, y_coords, n_sample, 'bicubic' ) ; 
    prof_mp2epic( :, ii ) = improfile( mp2epic_i, x_coords, y_coords, n_sample, 'bicubic' ) ; 

end

% Mean +- std
prof_a_mp2rage = mean( prof_mp2rage, 2 ) ;  
prof_s_mp2rage = std ( prof_mp2rage, 0, 2 ) ; 
prof_a_mp2epiu = mean( prof_mp2epiu, 2 ) ;  
prof_s_mp2epiu = std ( prof_mp2epiu, 0, 2 ) ; 
prof_a_mp2epic = mean( prof_mp2epic, 2 ) ; 
prof_s_mp2epic = std ( prof_mp2epic, 0, 2 ) ;




% Display
idx_GM_start_mp2rage = 30 ;
idx_GM_start_mp2epiu = 52 ;
idx_GM_start_mp2epic = 30 ;

figure( 'Color', 'w' ) ; 
hold on ;
grid on ;

x_axis          = linspace( 0, size( prof_mp2epic, 1 )-1, size( prof_mp2epic, 1 ) )' ;
x_patch         = [x_axis; flipud(x_axis)] ;
y_patch_mp2rage = [prof_a_mp2rage + prof_s_mp2rage; flipud(prof_a_mp2rage - prof_s_mp2rage)];
y_patch_mp2epiu = [prof_a_mp2epiu + prof_s_mp2epiu; flipud(prof_a_mp2epiu - prof_s_mp2epiu)];
y_patch_mp2epic = [prof_a_mp2epic + prof_s_mp2epic; flipud(prof_a_mp2epic - prof_s_mp2epic)];

fill( x_patch, y_patch_mp2rage, [0.5, 0.5, 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.4 ) ; 
plot( x_axis , prof_a_mp2rage, 'black', 'LineWidth', 2.5 ) ;

ru = prof_a_mp2rage(idx_GM_start_mp2rage)/prof_a_mp2epiu(idx_GM_start_mp2epiu) ;
fill( x_patch, y_patch_mp2epiu*ru, [0.8, 0.8, 1.0], 'EdgeColor', 'none', 'FaceAlpha', 0.4 ) ; 
plot( x_axis , prof_a_mp2epiu*ru, 'blue', 'LineWidth', 2.5 ) ;

rc = prof_a_mp2rage(idx_GM_start_mp2rage)/prof_a_mp2epic(idx_GM_start_mp2epic) ;
fill( x_patch, y_patch_mp2epic*rc, [1.0, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.4 ) ; 
plot( x_axis , prof_a_mp2epic*rc, 'red', 'LineWidth', 2.5 ) ;






