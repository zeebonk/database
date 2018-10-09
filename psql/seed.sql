DO $$
DECLARE
  v_user1_uuid uuid = '08BDE84B-757C-4EF9-BF9F-08B2366FF6F1';
  v_user_servce1_uuid uuid = '08BDE84B-757C-4EF9-BF9F-08B2366FF6F1';
  v_repo1_uuid uuid = 'F034F9D0-B36A-4AE4-858D-564265FA69C3';
BEGIN
  INSERT INTO owners (uuid, username, name) values (v_user1_uuid, 'user1', 'User One');
  INSERT INTO owner_vcs (uuid, owner_uuid, service_id, username) values (v_user_servce1_uuid, v_user1_uuid, '23598043290', 'user1');
  INSERT INTO repos (uuid, owner_vcs_uuid, service_id, name) values (v_repo1_uuid, v_user_servce1_uuid, '92385348957239', 'repo1');
  INSERT INTO services (repo_uuid, alias, topics, name, owner_uuid) values (v_repo1_uuid, 'repo1', ARRAY['topic', 'database', 'repo', 'microservices']::citext[], 'Foobar', v_user1_uuid);
END;
$$ LANGUAGE plpgsql;
