create table teams(
  teamid                  serial primary key,
  ownerid                 int references owners on delete cascade not null,  -- GitHub Org
  service_id              text not null,  -- GitHub internal id
  permissions             permission[]  -- Asyncy permissions
);
