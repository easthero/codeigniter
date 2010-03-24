<?php
/**
* 
*/
class Main extends MY_Controller{
	
	function Main(){
		parent::MY_Controller();
		$this->load->helper('url');
	}
	
	function index(){	
		$this->load->model('Users_model');
		$data['users'] = $this->Users_model->load_users();
		
		$this->load->view('header');
		$this->load->view('menu');
		$this->load->view('main_view', $data);
		$this->load->view('footer');

	}

}

?>