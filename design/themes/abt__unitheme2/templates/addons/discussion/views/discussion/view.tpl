{assign var="discussion" value=$object_id|fn_get_discussion:$object_type:true:$smarty.request}
{if $object_type == "Addons\\Discussion\\DiscussionObjectTypes::ORDER"|enum}
    {$new_post_title = __("new_post")}
{else}
    {$new_post_title = __("write_review")}
{/if}
{if $discussion && $discussion.type != "Addons\\Discussion\\DiscussionTypes::TYPE_DISABLED"|enum}
    <div class="discussion-block" id="{if $container_id}{$container_id}{else}content_discussion{/if}">
        {if $wrap == true}
            {capture name="content"}
            {include file="common/subheader.tpl" title=$title}
        {/if}

        {if $subheader}
            <h4>{$subheader}</h4>
        {/if}

        <div id="posts_list_{$object_id}">
            {if $discussion.posts}

                {* rb - reviews bar *}         
                       
                {if $object_type == "P"}
                <div class="left-col">
                        <div class="abt__ut2_rb">
                            <div class="rb-ratings">
                                <div class="rb-rounded-overall">
                                    {if $object_type == "E"}
                                        {if in_array($addons.discussion.home_page_testimonials, ['B', 'R'])}
                                            {if $discussion.average_rating}
                                                {$average_rating = $discussion.average_rating}
                                            {/if}
                                            {if $average_rating > 0}
                                                <div class="rb-average-rating">{$average_rating}</div>
                                                {if $settings.abt__device != "mobile"}<div class="rb-average-rating-title">{__("abt__ut2.discussion.asr_title")}</div>{/if}
                                                <div class="rb-stars">{include file="addons/discussion/views/discussion/components/stars.tpl" stars=$average_rating|fn_get_discussion_rating}</div>
                                                {if $settings.abt__device != "desktop"}
                                                    <div class="rb-average-rating-comments mobile">
                                                        {$discussion.search.total_items} {__("reviews", [$discussion.search.total_items])}<br/><span class="rb-average-rating-info">{__("abt__ut2.discussion.avr_part1")}:<br/>{$average_rating} {__("abt__ut2.discussion.avr_part2")}</span>
                                                    </div>
                                                {else}
                                                    <div class="rb-average-rating-comments">
                                                        {$discussion.search.total_items} {__("reviews", [$discussion.search.total_items])} <span class="rb-average-rating-info cm-tooltip" title="{__("abt__ut2.discussion.avr_part1")}: {$average_rating} {__("abt__ut2.discussion.avr_part2")}"><i class="ut2-icon-outline-info-circle"></i></span>
                                                    </div>
                                                {/if}
                                            {/if}
                                        {/if}
                                    {else}
                                        {if $discussion.type == "R" || $discussion.type == "B"}
                                            {if $discussion.average_rating}
                                                {$average_rating = $discussion.average_rating}
                                            {/if}
                                            {if $average_rating > 0}
                                                <div class="rb-average-rating">{$average_rating}</div>
                                                {if $settings.abt__device != "mobile"}<div class="rb-average-rating-title">{__("abt__ut2.discussion.asr_title")}</div>{/if}
                                                <div class="rb-stars">{include file="addons/discussion/views/discussion/components/stars.tpl" stars=$average_rating|fn_get_discussion_rating}</div>
                                                {if $settings.abt__device != "desktop"}
                                                    <div class="rb-average-rating-comments mobile">
                                                        {$discussion.search.total_items} {__("reviews", [$discussion.search.total_items])}<br/><span class="rb-average-rating-info">{__("abt__ut2.discussion.avr_part1")}:<br/>{$average_rating} {__("abt__ut2.discussion.avr_part2")}</span>
                                                    </div>
                                                {else}
                                                    <div class="rb-average-rating-comments">
                                                        {$discussion.search.total_items} {__("reviews", [$discussion.search.total_items])} <span class="rb-average-rating-info cm-tooltip" title="{__("abt__ut2.discussion.avr_part1")}: {$average_rating} {__("abt__ut2.discussion.avr_part2")}"><i class="ut2-icon-outline-info-circle"></i></span>
                                                    </div>
                                                {/if}
                                            {/if}
                                        {/if}
                                    {/if}
                                </div>
                            </div>
        
                            <div class="rb-histogram">
                                <div class="rb-review-histogram">
                                {foreach $discussion.search.posts_rating_count as $rating => $post_qty}
                                    <div class="rb-rating-filter">
                                        {if $post_qty}
                                            <a href="javascript:void(0);" class="rb-meter-inline cm-abt-filter-post link" data-ca-rating="{$rating}" data-ca-product-id="{$object_id}"><span>{__("abt__ut2.discussion.star", [$rating])}</span></a>
                                            <div class="meter histogram"><span class="rb-meter-bar" style="width: {($post_qty * 100) / $discussion.search.total_items}%;"></span></div>
                                        {else}
                                            <span class="rb-meter-inline zero">{__("abt__ut2.discussion.star", [$rating])}</span>
                                            <div class="meter histogram"><span class="rb-meter-bar" style="width: 0%;"></span></div>
                                        {/if}
                                        <span class="{if $post_qty == 0}zero{/if}">{$post_qty}</span>
                                    </div>
                                {/foreach}
                                </div>
                            </div>
        
                            <div class="rb-selected-filter" id="abt__discussion_buttons_{$object_id}">
                                {if $discussion.search.abt__rating}
                                    <div class="rb-stars">
                                        <p>{__("selected")}: {__("abt__ut2.discussion.star", [$discussion.search.abt__rating])} {include file="addons/discussion/views/discussion/components/stars.tpl" stars=$discussion.search.abt__rating|fn_get_discussion_rating}</p>
        
                                        <a href="javascript:void(0);" class="ty-btn cm-abt-filter-post" data-ca-rating="0" data-ca-product-id="{$object_id}">
                                            <span>{__("show_all")}</span>
                                        </a>
                                    </div>
                                {/if}
                            <!--abt__discussion_buttons_{$object_id}--></div>
                        </div>
                    {/if}
                    
                    {include file="common/pagination.tpl" id="pagination_contents_comments_`$object_id`" extra_url="&selected_section=discussion" search=$discussion.search}
    
                    {foreach $discussion.posts as $post}
                        <div class="ty-discussion-post__content ty-mb-l">
                            {hook name="discussion:items_list_row"}
    
                            <div class="ty-discussion-post {cycle values=", ty-discussion-post_even"}" id="post_{$post.post_id}">
                                {if $discussion.type == "Addons\\Discussion\\DiscussionTypes::TYPE_COMMUNICATION"|enum
                                    || $discussion.type == "Addons\\Discussion\\DiscussionTypes::TYPE_COMMUNICATION_AND_RATING"|enum
                                }
                                    <div class="ty-discussion-post__message {if  $settings.abt__ut2.addons.discussion.highlight_administrator === "Y" && $post.user_type === "A"}auth-admin{/if}">
                                        <div class="ty-discussion-post__message-author">
                                            <div class="ty-discussion-post__author">
                                                <div class="ty-discussion-post__avatar">
                                                    {* if buyer *}
                                                    {if $settings.abt__ut2.addons.discussion.verified_buyer === "Y" && $post.abt__is_buyer}
                                                        <span class="ut2-verified cm-tooltip" title="{__("abt__ut2.discussion.verified_buyer")}"><i class="ut2-icon-outline-check-circle"></i></span>
                                                    {/if}
                                                    {* if admin *}
                                                    {if  $settings.abt__ut2.addons.discussion.highlight_administrator === "Y" && $post.user_type === "A"}
                                                        <i class="ut2-icon-outline-headset_mic"></i>
                                                    {else}
                                                        {fn_substr(trim($post.name), 0, 1)}
                                                    {/if}
                                                </div>
                                                <p><b>{$post.name}</b>
                                                {* if buyer *}
                                                {if $settings.abt__ut2.addons.discussion.verified_buyer === "Y" && $post.abt__is_buyer}
                                                    <span class="ut2-vr-user">{__("abt__ut2.discussion.verified_buyer_bp")}</span>
                                                {/if}
                                                <span class="ty-discussion-post__date">{$post.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</span></p>
                                            </div>
                                            {* if not Admin *}
                                            {if $post.user_type !== "A"}
                                                <div class="ty-discussion-post__rating-stars">
                                                    {if $discussion.type == "Addons\\Discussion\\DiscussionTypes::TYPE_RATING"|enum
                                                        || $discussion.type == "Addons\\Discussion\\DiscussionTypes::TYPE_COMMUNICATION_AND_RATING"|enum
                                                        && $post.rating_value > 0
                                                    }
                                                        <div class="clearfix ty-discussion-post__rating">
                                                            {include file="addons/discussion/views/discussion/components/stars.tpl" stars=$post.rating_value|fn_get_discussion_rating}
                                                        </div>
                                                    {/if}
                                                </div>
                                            {/if}
                                        </div>
                                        <div class="ty-discussion-post__message-text">
                                        {if fn_strlen($post.message) > 530}
                                                <div class="clipped">
                                                    <p>{$post.message|escape|nl2br nofilter}</p>
                                                </div>
                                                <a class="ut2-more-btn" href="javascript:void(0);" onclick="$(this).prev().toggleClass('view');$(this).toggleClass('open');"><i class="ut2-icon-outline-expand_more"></i><span class="see-more">{__("abt__ut2.discussion.see_more")}</span><span class="see-less">{__("abt__ut2.discussion.see_less")}</span></a>
                                            {else}
                                                <p>{$post.message|escape|nl2br nofilter}</p>
                                        {/if}
                                        </div>
                                    </div>
                                {else}
                                    <div class="ty-discussion-post__message">
                                        <div class="ty-discussion-post__message-author">
                                            <div class="ty-discussion-post__author">
                                                <div class="ty-discussion-post__avatar">
                                                    {* if buyer *}
                                                    {if $settings.abt__ut2.addons.discussion.verified_buyer === "Y" && $post.abt__is_buyer}
                                                        <span class="ut2-verified cm-tooltip" title="{__("abt__ut2.discussion.verified_buyer")}"><i class="ut2-icon-outline-check-circle"></i></span>
                                                    {/if}
                                                    {fn_substr(trim($post.name), 0, 1)}
                                                </div>
                                                <p><b>{$post.name}</b>
                                                {* if buyer *}
                                                {if $settings.abt__ut2.addons.discussion.verified_buyer === "Y" && $post.abt__is_buyer}
                                                    <span class="ut2-vr-user">{__("abt__ut2.discussion.verified_buyer_bp")}</span>
                                                {/if}
                                                <span class="ty-discussion-post__date">{$post.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</span></p>
                                            </div>
                                            <div class="ty-discussion-post__rating-stars">
                                                <div class="clearfix ty-discussion-post__rating">
                                                    {include file="addons/discussion/views/discussion/components/stars.tpl" stars=$post.rating_value|fn_get_discussion_rating}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                {/if}
                            </div>
    
                            {/hook}
                        </div>
                    {/foreach}
    
                    {include file="common/pagination.tpl" id="pagination_contents_comments_`$object_id`" extra_url="&selected_section=discussion" search=$discussion.search}
                
                {if $object_type == "P"}</div>
                {/if}
                {* End left-col *}
                
                {if $object_type == "P"}
                    <div class="right-col">
                        <div class="rb-buttons">
                            <div class="rb-title">{__("abt__ut2.discussion.new_post_title")}</div>
                            <p>{__("abt__ut2.discussion.new_post_descr")}</p>
                            {if $discussion.type !== "Addons\\Discussion\\DiscussionTypes::TYPE_DISABLED"|enum}
                            {include file="addons/discussion/views/discussion/components/new_post_button.tpl" name=$new_post_title obj_id=$object_id object_type=$discussion.object_type locate_to_review_tab=$locate_to_review_tab}
                            {/if}
                        </div>
                    </div>
                {else}
                    {if $discussion.type !== "Addons\\Discussion\\DiscussionTypes::TYPE_DISABLED"|enum}
                    {include file="addons/discussion/views/discussion/components/new_post_button.tpl" name=$new_post_title obj_id=$object_id object_type=$discussion.object_type locate_to_review_tab=$locate_to_review_tab}
                    {/if}              
                {/if}
                {* End right-col *}
                
                {else}
                <div class="rb-no-items">
                    {if $object_type == "P"}
                        <p class="ty-no-items">{__("no_posts_found")}</p>
                        <div class="rb-buttons">
                            <div class="rb-title">{__("abt__ut2.discussion.new_post_title")}</div>
                            <p>{__("abt__ut2.discussion.new_post_descr")}</p>
                            {if $discussion.type !== "Addons\\Discussion\\DiscussionTypes::TYPE_DISABLED"|enum}
                            {include file="addons/discussion/views/discussion/components/new_post_button.tpl" name=$new_post_title obj_id=$object_id object_type=$discussion.object_type locate_to_review_tab=$locate_to_review_tab}
                            {/if}
                        </div>
                    {else}
                        <p class="ty-no-items">{__("no_posts_found")}</p>
                        {if $discussion.type !== "Addons\\Discussion\\DiscussionTypes::TYPE_DISABLED"|enum}
                        {include file="addons/discussion/views/discussion/components/new_post_button.tpl" name=$new_post_title obj_id=$object_id object_type=$discussion.object_type locate_to_review_tab=$locate_to_review_tab}
                        {/if}
                    {/if}
                </div>
            {/if}
        <!--posts_list_{$object_id}--></div>

        {if $wrap == true}
            {/capture}
            {$smarty.capture.content nofilter}
        {else}
            {capture name="mainbox_title"}{$title}{/capture}
        {/if}
    </div>
{/if}