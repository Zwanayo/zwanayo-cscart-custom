{hook name="buttons:add_to_cart"}
    {assign var="c_url" value=$config.current_url|escape:url}
    {if $settings.Checkout.allow_anonymous_shopping == "allow_shopping" || $auth.user_id}
        {if $show_price_in_button}
            {capture name="product_price_in_button"}
                {include file="common/price.tpl" value=$product.price}
            {/capture}
            {$but_text = $but_text|default:__("add_to_cart")}
            {if $product.price|floatval > 0}
                {$but_text = "{$but_text}&nbsp;-&nbsp;{$smarty.capture.product_price_in_button}"}
                {$btn_nofilter = true}
            {/if}
        {else}
            {$but_text = $but_text|default:__("add_to_cart")}
            {$btn_nofilter = false}
        {/if}
        {include file="buttons/button.tpl" but_id=$but_id btn_nofilter=$btn_nofilter but_text=$but_text but_name=$but_name but_onclick=$but_onclick but_href=$but_href but_target=$but_target but_role=$but_role|default:"text" but_meta="ty-btn__primary ty-btn__add-to-cart cm-form-dialog-closer `$but_meta`" but_icon="ut2-icon-use_icon_cart"}
    {else}

        {if $runtime.controller == "auth" && $runtime.mode == "login_form"}
            {assign var="login_url" value=$config.current_url}
        {else}
            {assign var="login_url" value="auth.login_form?return_url=`$c_url`"}
        {/if}

        {include file="buttons/button.tpl" but_id=$but_id but_text=__("sign_in_to_buy") but_title=__("text_login_to_add_to_cart") but_href=$login_url but_role=$but_role|default:"text" but_name="" but_meta="cm-tooltip ty-btn__tertiary ut2-allow-shopping" but_icon="ut2-icon-outline-info"}
        <p>{__("text_login_to_add_to_cart") nofilter}</p>
    {/if}
{/hook}
{* Change the Buy now button behavior using a hook *}
{$show_buy_now = $show_buy_now scope = parent}