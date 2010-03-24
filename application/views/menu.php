<?php
$menu = array('dashboard' => '系统状态', 'user' => '用户管理', 'settings' => '系统设置', 'event' => '事情查询');
?>
<div id="menu">
	<ul class="lavaLampWithImage">
		<?php foreach($menu as $url => $title):?>
			<li><?=anchor($url, $title)?></li>
		<?php endforeach?>
	</ul>
</div>