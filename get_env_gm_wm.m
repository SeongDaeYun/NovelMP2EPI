
% ========================================================================
% * Function: h1 = get_env_gm_wm( mp2epi_bi, mp2epi_ug, mp2epi_cg, mp2epi_uw, mp2epi_cw, sel_slc )
%             - draw gm and wm boundaries
%
% * Input : 
%           --------------------------------------------------------------
%                        |               Description
%           --------------------------------------------------------------
%           mp2epi_bi    | background image (*.nii)
%           mp2epi_ug    | GM prob. map of uncorrected (*.nii)
%           mp2epi_uw    | WM prob. map of uncorrected (*.nii)
%           mp2epi_cg    | GM prob. map of corrected (*.nii)
%           mp2epi_cw    | WM prob. map of corrected (*.nii)
%           sel_slc      | selected slice index
%           --------------------------------------------------------------
%
% * Output : 
%           --------------------------------------------------------------
%                        |               Description
%           --------------------------------------------------------------
%           h1           | figure handle
%           --------------------------------------------------------------
%
% * Dev.: Seong Dae Yun (s.yun@fz-juelich.de)
% * Ref.: Yun et al. A Novel Distortion-Matched Anatomical Imaging Sequence for 
%         High-Fidelity Functional Mapping in Submillimeter-Resolution fMRI.
%         Sci Rep. 2026. doi: 10.1038/s41598-026-58377-2. in press.
% ========================================================================


function h1 = get_env_gm_wm( mp2epi_bi, mp2epi_ug, mp2epi_uw, mp2epi_cg, mp2epi_cw, sel_slc )


    % Colors
    col1 = [1.00 1.00 0.20] ;
    col2 = [0.20 0.52 1.00] ;
    
    
    % ------- uncorrected: GM --------------------------------------------
    gm_mp2epi_ui = get_bd( mp2epi_ug( :, :, sel_slc ), 128, 100 ) ;
    
    len_cl = zeros( length( gm_mp2epi_ui ), 1 ) ;
    for k = 1 : 1 : length( gm_mp2epi_ui )
        len_cl( k ) = size( gm_mp2epi_ui{k}, 1 ) ;
    end
    mat_st = zeros( length( gm_mp2epi_ui ), 2 ) ;
    mat_st( :, 1 ) = len_cl ;
    mat_st( :, 2 ) = ( 1:1:length( gm_mp2epi_ui ) ).' ;
    mat_sr = flipud( sortrows( mat_st, 1 ) ) ;
    
    h1 = figure ;
    imshow( mp2epi_bi( :, :, sel_slc ), [0 max_all( mp2epi_bi( :, :, sel_slc ) )*0.85] ) ; hold on ;
    for k = 1 : 1 : 10
        tb_ns_k = gm_mp2epi_ui{mat_sr(k,2)} ;
        plot( tb_ns_k( :, 2 ), tb_ns_k( :, 1 ), 'Color', col1, 'LineWidth', 2 ) ;
    end
    
    
    % ------- uncorrected: WM --------------------------------------------
    wm_mp2epi_ui = get_bd( mp2epi_uw( :, :, sel_slc ), 120, 100 ) ;
    
    len_cl = zeros( length( wm_mp2epi_ui ), 1 ) ;
    for k = 1 : 1 : length( wm_mp2epi_ui )
        len_cl( k ) = size( wm_mp2epi_ui{k}, 1 ) ;
    end
    mat_st = zeros( length( wm_mp2epi_ui ), 2 ) ;
    mat_st( :, 1 ) = len_cl ;
    mat_st( :, 2 ) = ( 1:1:length( wm_mp2epi_ui ) ).' ;
    mat_sr = flipud( sortrows( mat_st, 1 ) ) ;
    
    for k = 2 : 1 : 3
        tb_ns_k = wm_mp2epi_ui{mat_sr(k,2)} ;
        plot( tb_ns_k( :, 2 ), tb_ns_k( :, 1 ), 'Color', col1, 'LineWidth', 2 ) ;
    end
    
    
    
    
    % ------- corrected: GM ----------------------------------------------
    gm_mp2epi_ci = get_bd( mp2epi_cg( :, :, sel_slc ), 128, 100 ) ;
    
    len_cl = zeros( length( gm_mp2epi_ci ), 1 ) ;
    for k = 1 : 1 : length( gm_mp2epi_ci )
        len_cl( k ) = size( gm_mp2epi_ci{k}, 1 ) ;
    end
    mat_st = zeros( length( gm_mp2epi_ci ), 2 ) ;
    mat_st( :, 1 ) = len_cl ;
    mat_st( :, 2 ) = ( 1:1:length( gm_mp2epi_ci ) ).' ;
    mat_sr = flipud( sortrows( mat_st, 1 ) ) ;
    
    for k = 1 : 1 : 10
        tb_ns_k = gm_mp2epi_ci{mat_sr(k,2)} ;
        plot( tb_ns_k( :, 2 ), tb_ns_k( :, 1 ), 'Color', col2, 'LineWidth', 2 ) ;
    end
    
    
    % ------- corrected: WM ----------------------------------------------
    wm_mp2epi_ci = get_bd( mp2epi_cw( :, :, sel_slc ), 120, 100 ) ;
    
    len_cl = zeros( length( wm_mp2epi_ci ), 1 ) ;
    for k = 1 : 1 : length( wm_mp2epi_ci )
        len_cl( k ) = size( wm_mp2epi_ci{k}, 1 ) ;
    end
    mat_st = zeros( length( wm_mp2epi_ci ), 2 ) ;
    mat_st( :, 1 ) = len_cl ;
    mat_st( :, 2 ) = ( 1:1:length( wm_mp2epi_ci ) ).' ;
    mat_sr = flipud( sortrows( mat_st, 1 ) ) ;
    
    for k = 2 : 1 : 3
        tb_ns_k = wm_mp2epi_ci{mat_sr(k,2)} ;
        plot( tb_ns_k( :, 2 ), tb_ns_k( :, 1 ), 'Color', col2, 'LineWidth', 2 ) ;
    end
    
    
    % Function: get boundaries
    function tb_ns = get_bd( seg_mask, thre_gm, thre_cl )
    
        t1_ns = seg_mask ;
        t2_ns = zeros( size( t1_ns ) ) ;
        t2_ns( t1_ns > thre_gm ) = 1 ;
        
        % Reduce small clusters
        t3_ns = bwareaopen( t2_ns, thre_cl ) ;
        
        % Keep only the largest connected component 
        cc = bwconncomp( t3_ns ) ;
        numPixels = cellfun( @numel, cc.PixelIdxList ) ;
        [~, idx] = max( numPixels ) ;
        t4_ns = zeros( size( t3_ns ) ) ;
        t4_ns( cc.PixelIdxList{idx} ) = 1 ;
        
        % Smooth
        t5_ns = smooth3( repmat( t4_ns, [1 1 21] ), 'gaussian', [3 3 3] ) ;
        tb_ns = bwboundaries( t5_ns( :, :, 11 ) > 0.3 ) ;
    
    end



end

