{assign var="product_detail_view_url" value="products.view?product_id=`$product.product_id`"}
{capture name="product_detail_view_url"}
{** Sets product detail view link *}
{hook name="products:product_detail_view_url"}
{$product_detail_view_url}
{/hook}
{/capture}

{$product_detail_view_url = $smarty.capture.product_detail_view_url|trim}
{if in_array($settings.abt__ut2.product_list.products_multicolumns.enable_hover_gallery.{$settings.abt__device}, ["lines", "points"])}
    {$show_gallery = false}
{/if}

{capture name="main_icon"}
    <a href="{"$product_detail_view_url"|fn_url}">
        {include file="common/image.tpl" 
            obj_id=$obj_id_prefix 
            images=$product.main_pair
            image_width=$image_width
            image_height=$image_height
            class="img-ab-hover-gallery"
           }
        {if in_array($settings.abt__ut2.product_list.{$tmpl}.enable_hover_gallery.{$settings.abt__device}, ["lines", "points"])}
            {include file="views/products/components/ab__hover_gallery.tpl"
                image_pairs=$product.image_pairs
                image_width=$image_width
                image_height=$image_height
                additional_class=$settings.abt__ut2.product_list.{$tmpl}.enable_hover_gallery.{$settings.abt__device}
            }
        {/if}
    </a>
{/capture}

{if $product.image_pairs && $show_gallery}
<div class="ty-center-block">
    <div class="ty-thumbs-wrapper owl-carousel cm-image-gallery ty-scroller" 
        data-ca-items-count="1"
        data-ca-items-responsive="true"
        data-ca-scroller-item="1"
        data-ca-scroller-item-desktop="1"
        data-ca-scroller-item-desktop-small="1"
        data-ca-scroller-item-tablet="1"
        data-ca-scroller-item-mobile="1"
        data-ca-product-list="{$tmpl}"
        id="icons_{$obj_id_prefix}">
        {if $product.main_pair}
            <div class="cm-gallery-item cm-item-gallery ty-scroller__item">
                {$smarty.capture.main_icon nofilter}
            </div>
        {/if}
        {$fewer_items = array_slice($product.image_pairs, 0, 5, true)}
        {foreach from=$fewer_items item="image_pair"}
            {if $image_pair}
                <div class="cm-gallery-item cm-item-gallery ty-scroller__item">
                    <a href="{"$product_detail_view_url"|fn_url}">
                        {include file="common/image.tpl" no_ids=true 
                            images=$image_pair 
                            image_width=$image_width
                            image_height=$image_height
                           }
                    </a>
                </div>
            {/if}
        {/foreach}
    </div>
</div>
{else}
    {$smarty.capture.main_icon nofilter}
{/if}