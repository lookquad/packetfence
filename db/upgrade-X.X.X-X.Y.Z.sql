--
-- PacketFence SQL schema upgrade from X.X.X to X.Y.Z
--

-- Adding locationlog trigger to archive old DHCP location log on update or insert

DROP TRIGGER IF EXISTS locationlog_insert_in_locationlog_archive_before_insert_trigger;
DELIMITER /
CREATE TRIGGER locationlog_insert_in_locationlog_archive_before_insert_trigger BEFORE INSERT ON locationlog
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
           ( NEW.mac, NEW.switch, NEW.port,
             NEW.vlan, NEW.role, NEW.connection_type,
             NEW.connection_sub_type, NEW.dot1x_username, NEW.ssid,
             NEW.start_time, NEW.end_time, NEW.switch_ip,
             NEW.switch_mac, NEW.stripped_user_name, NEW.realm,
             NEW.session_id
           );

  END IF;
END /

DROP TRIGGER IF EXISTS locationlog_insert_in_locationlog_archive_before_update_trigger;
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
           ( NEW.mac, NEW.switch, NEW.port,
             NEW.vlan, NEW.role, NEW.connection_type,
             NEW.connection_sub_type, NEW.dot1x_username, NEW.ssid,
             NEW.start_time, NEW.end_time, NEW.switch_ip,
             NEW.switch_mac, NEW.stripped_user_name, NEW.realm,
             NEW.session_id
           );

  END IF;
END /
DELIMITER ;

