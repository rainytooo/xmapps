  def authcode(str,decode=true,key='',expiry=0)   
    return nil unless str
    str = decode ? str+'====' : str.gsub(/\\t/,"\t")
    require 'base64'
    ckey_length = 4
    key = Digest::MD5.hexdigest(!key.empty? ? key : UC_KEY)   
    keya = Digest::MD5.hexdigest(key[0,16])   
    keyb = Digest::MD5.hexdigest(key[16,16])   
    keyc = decode ? str[0,ckey_length] : Digest::MD5.hexdigest("#{Time.now.to_f} #{Time.now.to_i}")[-ckey_length,ckey_length]
    cryptkey = keya + Digest::MD5.hexdigest(keya+keyc)   
    key_length = cryptkey.size
    str = decode ?  Base64.decode64(str[ckey_length..-1])  : format("%010d",(expiry!=0 ? expiry + Time.now.to_i : 0)).to_s  + Digest::MD5.hexdigest(str+keyb)[0,16]+str   
    str_length = str.size
    result = ''  
    box = {}   
    (0..255).each  { |i| box[i] = i}   
  
    rndkey = {}   
    (0..255).each do |i|   
      rndkey[i] = cryptkey[i % key_length,1][0]   
    end
    
     j = 0   
    (0..255).each do |i|   
      j = (j + box[i].to_i + rndkey[i].to_i) % 256   
      tmp = box[i]   
      box[i] = box[j]   
      box[j] = tmp   
    end  
  
    a=j=0
    (0..str_length-1).each do |i|   
      a = (a+1) % 256   
      j = (j + box[a]) % 256   
      tmp = box[a]   
      box[a] = box[j]   
      box[j] = tmp   
      ks = box[(box[a].to_i + box[j].to_i)%256]   
      result  << (str[i].to_i ^ ks.to_i ).chr   
    end
    
    if decode   
      if (result[0,10].to_i ==0 || (result[0,10].to_i - Time.now.to_i) > 0) && result[10,16] == (Digest::MD5.hexdigest(result[26..-1] + keyb)[0,16])   
        return result[26..-1]   
      else  
        return ''  
      end  
    else      
      return keyc+Base64.b64encode(result).sub('=','')
    end
  end