<?php
/**
* 
*/
class Dashboard extends MY_Controller
{

	function index(){
		$this->load->view('header');
		$this->load->view('menu');
		$this->load->view('dashboard');
		$this->load->view('footer');
	}

}

?>