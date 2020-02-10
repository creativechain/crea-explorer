<?php
namespace CrearyDB\Models;

class Account extends Document
{

  public function profileImage() {
    if(property_exists($this, 'json_metadata') && !is_array($this->json_metadata)) {
        $this->json_metadata = json_decode($this->json_metadata, true);
    }
    if(property_exists($this, 'json_metadata') && isset($this->json_metadata['avatar']) && isset($this->json_metadata['avatar']['hash'])) {
        return 'https://ipfs3.creary.net/ipfs/' . $this->json_metadata['avatar']['hash'];
    }
    return null;
  }

}
