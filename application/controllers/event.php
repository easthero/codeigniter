<?php
/**
* 
*/
class Event extends MY_Controller
{

	function index(){
		$this->load->view('header');
		$this->load->view('menu');
		$this->load->view('event');
		$this->load->view('footer');
	}

}

?>