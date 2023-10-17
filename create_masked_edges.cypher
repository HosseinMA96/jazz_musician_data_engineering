//Make the binary mask with COMMON edges. Note that due to memory limitations, we use LIMIT and SKIP keywords to do it in 2000000 roww batches
MATCH ()-[r:years]->()
WITH r, startNode(r) AS start_node, endNode(r) AS end_node
LIMIT 2000000
MERGE (start_node)-[edge:COMMON]->(end_node)
ON CREATE SET edge.vector = [x IN range(0, 40) | CASE WHEN x = toInteger(r.year) - 1929 THEN 1 ELSE 0 END]
ON MATCH SET edge.vector = [i IN range(0, 40) | CASE WHEN i = toInteger(r.year) - 1929 THEN edge.vector[i] + 1 ELSE edge.vector[i] END]
RETURN edge, start_node, end_node;



//Inspect newly created COMMON edges (binary masks)
Match (n1) -[r:COMMON] -> (n2)
return  n1, n2, r



//Delete all COMMON edges
Match (n1) -[r:COMMON] -> (n2)
delete r


//Find all sessions n1 had with its neighbors. Each edge is a session and its attribute is the year
Match (n1) -[r:years] -> (n2)
where n1.musician_id = '50'
return n1, r, n2


//Find all sessions n1 had with its neighbors. Each edge is a binary vector where each element corresponds to how many sessions did the two
//In the corresponding year
Match (n1:new) -[r:COMMON] -> (n2:new)
where n1.musician_id = '50'
return n1, r, n2


//Now if we run the python script and enter 1929 and 1969 as the starting and ending year respectively,
//And also add the WHERE n1.musician_id = '50' statement for an arbitrary node, we will get this query
//If we run this query, we will create the NEW_EDGE where it points out how many sessions did '50' had with all of its collaborators
//In the years of interest
WITH [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] AS A
MATCH (n1)-[oldEdge:COMMON]->(n2)
WHERE n1.musician_id = '50'
WITH n1, n2, oldEdge,
REDUCE(acc = 0, i IN RANGE(0, 40) | acc + A[i] * oldEdge.vector[i]) AS dotProduct
WHERE dotProduct > 0
CREATE (n1)-[:NEW_EDGE {dotProduct: dotProduct}]->(n2);


//Use this to visualize the collaboration edges for '50' in the years of interest
Match (n1:new) -[r:NEW_EDGE] -> (n2:new)
where n1.musician_id = '50'
return n1, r, n2

//Use this to delete NEW_EDGES and start investigating another node
Match (n1) -[r:NEW_EDGE] -> (n2)
delete r



