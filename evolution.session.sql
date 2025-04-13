INSERT INTO Chat (
    id,
    remoteJid,
    labels,
    createdAt,
    updatedAt,
    instanceId,
    name
  )
VALUES (
    'id:text',
    'remoteJid:character varying',
    'labels:jsonb',
    'createdAt:timestamp without time zone',
    'updatedAt:timestamp without time zone',
    'instanceId:text',
    'name:character varying'
  );