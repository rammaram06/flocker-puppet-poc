node 'flocker-01' { 
	include docker
	contain flocker
}

node 'flocker-02' { 
	include docker
	contain flocker
}
