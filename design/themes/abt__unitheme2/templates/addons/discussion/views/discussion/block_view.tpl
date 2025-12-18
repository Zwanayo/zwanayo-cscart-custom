{$discussion = $object_id|fn_get_discussion:$object_type:true:$smarty.request}

{if $discussion && $discussion.type != "D"}
    {include file="common/subheader.tpl" title=$title}

    <div id="posts_list_{$object_id}">
    {if $discussion.posts}
        <div class="ty-mb-l">
            <div class="ty-scroller-discussion-list">
                <div id="scroll_list_discussion" class="owl-carousel ty-scroller-list">
                    {foreach from=$discussion.posts item=post}
                        <div class="ty-discussion-post__content ty-mb-l">

                        {hook name="discussion:items_list_row"}

                        <div class="ty-discussion-post {cycle values=", ty-discussion-post_even"}" id="post_{$post.post_id}">
                            {if $discussion.type == "Addons\\Discussion\\DiscussionTypes::TYPE_COMMUNICATION"|enum
                                || $discussion.type == "Addons\\Discussion\\DiscussionTypes::TYPE_COMMUNICATION_AND_RATING"|enum
                            }
                                <div class="ty-discussion-post__message{if $settings.abt__ut2.addons.discussion.highlight_administrator === "Y" && $post.user_type === "UserTypes::ADMIN"|enum} auth-admin{/if}">
                                    <div class="ty-discussion-post__message-author">
                                        <div class="ty-discussion-post__author">
                                            <div class="ty-discussion-post__avatar">
                                                {* if admin *}
                                                {if $settings.abt__ut2.addons.discussion.highlight_administrator === "Y" && $post.user_type === "A"}
                                                    <i class="ut2-icon-outline-headset_mic"></i>
                                                {else}
                                                    {fn_substr(trim($post.name), 0, 1)}
                                                {/if}
                                            </div>
                                            <p><b>{$post.name}</b><br/>
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
                                    {if fn_strlen($post.message) > 300}
                                            <div class="clipped">
                                                <p>{$post.message|escape|nl2br nofilter}</p>
                                            </div>
                                            <a class="ut2-more-btn" href="javascript:void(0);" onclick="$(this).prev().toggleClass('view');$(this).toggleClass('open');"><i class="ut2-icon-outline-expand_more"></i><span class="see-more">{__("abt__ut2.discussion.see_more")}</span><span class="see-less">{__("abt__ut2.discussion.see_less")}</span></a>
                                        {else}
                                            <p>{$post.message|escape|nl2br nofilter}</p>                                 
                                    {/if}
                                    </div>
                                </div>
                            {/if}
                        </div>
                        
                        {/hook}

                        </div>
                    {/foreach}
                </div>
            </div>
        </div>
    {else}
        <p class="ty-no-items">{__("no_data")}</p>
    {/if}
    <!--posts_list_{$object_id}--></div>

    {if $object_type == "P"}
        {$new_post_title = __("write_review")}
    {else}
        {$new_post_title = __("new_post")}
    {/if}

    {if $discussion.type !== "Addons\\Discussion\\DiscussionTypes::TYPE_DISABLED"|enum}
        {include
            file="addons/discussion/views/discussion/components/new_post_button.tpl"
            name=__("write_review")
            obj_id=$object_id
            object_type=$discussion.object_type
        }
    {/if}

    {$block = ["block_id" => "discussion", "properties" => ["item_quantity" => 2, "scroll_per_page" => "Y", "not_scroll_automatically" => "Y", "outside_navigation" => true]]}
    {include file="common/scroller_init_with_quantity.tpl" block=$block itemsDesktop=3 itemsDesktopSmall=2 itemsTablet=2 itemsTabletSmall=1 itemsMobile=1}

{/if}