package tomcat.socket;

import java.util.ArrayList;

import com.google.gson.Gson;

import jakarta.websocket.EncodeException;
import jakarta.websocket.Encoder;

public class MessageListEncoder implements Encoder.Text<ArrayList<ChatMessage>>{

	@Override
	public String encode(ArrayList<ChatMessage> object) throws EncodeException {
		return new Gson().toJson(object);
	}
}
