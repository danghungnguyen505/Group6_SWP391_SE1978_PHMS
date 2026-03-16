package dal;

import java.sql.*;
import java.util.*;
import model.ChatMessage;
import model.User;

public class ChatMessageDAO extends DBContext {

    public void sendMessage(ChatMessage msg) {

    String sql = "INSERT INTO ChatMessage(sender_id, receiver_id, message_text, sent_time) VALUES (?, ?, ?, ?)";

    try {

        PreparedStatement ps = connection.prepareStatement(sql);

        ps.setInt(1, msg.getSenderId());
        ps.setInt(2, msg.getReceiverId());
        ps.setString(3, msg.getMessageText());
        ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));

        ps.executeUpdate();

    } catch (Exception e) {
        e.printStackTrace();
    }
}

    public List<ChatMessage> getConversation(int user1, int user2) {

        List<ChatMessage> list = new ArrayList<>();

        String sql = """
            SELECT c.*, u.full_name AS senderName
            FROM ChatMessage c
            JOIN Users u ON c.sender_id = u.user_id
            WHERE (sender_id=? AND receiver_id=?)
            OR (sender_id=? AND receiver_id=?)
            ORDER BY sent_time
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, user1);
            ps.setInt(2, user2);
            ps.setInt(3, user2);
            ps.setInt(4, user1);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                ChatMessage m = new ChatMessage();

                m.setMessageId(rs.getInt("message_id"));
                m.setSenderId(rs.getInt("sender_id"));
                m.setReceiverId(rs.getInt("receiver_id"));
                m.setMessageText(rs.getString("message_text"));
                m.setSentTime(rs.getTimestamp("sent_time"));
                m.setSenderName(rs.getString("senderName"));

                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<User> getCustomersWhoMessaged(int receptionistId) {

    List<User> list = new ArrayList<>();

   String sql = """
    SELECT DISTINCT u.user_id, u.full_name
    FROM ChatMessage m
    JOIN Users u ON m.sender_id = u.user_id
    WHERE m.receiver_id = ?
""";

    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, receptionistId);

        ResultSet rs = ps.executeQuery();

        while(rs.next()){
            User u = new User();
            u.setUserId(rs.getInt("user_id"));
            u.setFullName(rs.getString("full_name"));
            list.add(u);
        }

    } catch(Exception e){
        e.printStackTrace();
    }

    return list;
}
}