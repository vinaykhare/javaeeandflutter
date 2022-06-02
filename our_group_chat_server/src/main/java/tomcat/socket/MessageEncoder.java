package tomcat.socket;

import com.google.gson.Gson;

import jakarta.websocket.EncodeException;
import jakarta.websocket.Encoder;

public class MessageEncoder implements Encoder.Text<ChatMessage> {

	@Override
	public String encode(ChatMessage object) throws EncodeException {
		
		return new Gson().toJson(object);
	}

}
