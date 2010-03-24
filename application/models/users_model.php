<?php
/**
* 
*/
class Users_model extends Model
{
	
	function load_users(){
		$query = $this->db->get('users');
		return $query->result();
	}

}

?>