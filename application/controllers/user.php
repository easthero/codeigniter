<?php
/**
* 
*/
class User extends MY_Controller
{

	function index(){
		$this->load->view('header');
		$this->load->view('menu');
		$this->load->view('user');
		$this->load->view('footer');
	}

}

?>