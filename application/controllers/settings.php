<?php
/**
* 
*/
class Settings extends MY_Controller
{

	function index(){
		$this->load->view('header');
		$this->load->view('menu');
		$this->load->view('settings');
		$this->load->view('footer');
	}

}

?>