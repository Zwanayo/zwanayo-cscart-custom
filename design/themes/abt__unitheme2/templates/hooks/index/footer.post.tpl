{* ZwaChat widget (fixed bottom-right) *}
<div id="zwachat_container" style="position:fixed; right:16px; bottom:16px; z-index:2147483000; width:360px; max-width:90vw; pointer-events:auto;">
  <iframe
    src="https://chat.zwanayo.com/widget?admin=1"
    style="width:100%; height:560px; border:0; border-radius:12px; overflow:hidden; display:block;"
    referrerpolicy="no-referrer-when-downgrade">
  </iframe>
  <noscript><a href="https://chat.zwanayo.com/widget" target="_blank" rel="noopener">Open ZwaChat</a></noscript>
</div>
{if $smarty.request.debug}
{literal}
<style>
  #zwachat_container{outline:2px dashed #ff3b30; background:rgba(255,59,48,.04)}
  #zwachat_debug_badge{
    position:fixed; left:16px; bottom:16px; z-index:2147483001;
    background:#0b1220; color:#fff; font:12px/1.2 system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;
    padding:6px 8px; border-radius:6px; box-shadow:0 1px 4px rgba(0,0,0,.2);
  }
</style>
<div id="zwachat_debug_badge">ZwaChat injected ✓</div>
<script>
  (function(){
    try{
      var el=document.getElementById('zwachat_container');
      console.log('[ZwaChat] container present:', !!el, el);
      if(!el) alert('ZwaChat container not found (footer.post.tpl)');
    }catch(e){ console.warn('[ZwaChat][debug]', e); }
  })();
</script>
{/literal}
{/if}