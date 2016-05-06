--
-- PacketFence SQL schema upgrade from X.X.X to X.Y.Z
--

-- Adding locationlog trigger to archive old DHCP location log on update or insert

DROP TRIGGER IF EXISTS locationlog_insert_in_locationlog_archive_before_update_trigger;
DELIMITER /
CREATE TRIGGER locationlog_insert_in_locationlog_archive_before_update_trigger BEFORE UPDATE ON locationlog
FOR EACH ROW
BEGIN
  IF (NEW.connection_type IS NOT NULL AND NEW.connection_type = "DHCP") THEN
    INSERT INTO locationlog_archive
           ( mac, switch, port,
             vlan, role, connection_type,
             connection_sub_type, dot1x_username, ssid,
             start_time, end_time, switch_ip,
             switch_mac, stripped_user_name, realm,
             session_id
           )
    VALUES
           ( OLD.mac, OLD.switch, OLD.port,
             OLD.vlan, OLD.role, OLD.connection_type,
             OLD.connection_sub_type, OLD.dot1x_username, OLD.ssid,
             OLD.start_time, OLD.end_time, OLD.switch_ip,
             OLD.switch_mac, OLD.stripped_user_name, OLD.realm,
             OLD.session_id
           );
  END IF;
END /
DELIMITER ;

