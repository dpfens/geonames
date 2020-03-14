ALTER TABLE `hierarchy`
ADD CONSTRAINT `fk_hierarchy_parent_id`
FOREIGN KEY (`parentId`) REFERENCES `geoName`(`geonameid`)
ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE `hierarchy`
ADD CONSTRAINT `fk_hierarchy_child_id`
FOREIGN KEY (`childId`) REFERENCES `geoName`(`geonameid`)
ON DELETE RESTRICT ON UPDATE RESTRICT;
