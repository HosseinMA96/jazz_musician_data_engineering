//View sessions
Match (n1) -[r:years] -> (n2)
where n1.musician_id = '50'
return n1, r, n2


//Show sessions common vectors
Match (n1:new) -[r:COMMON] -> (n2:new)
where n1.musician_id = '50'
return n1, r, n2

//Generate new edges
WITH [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] AS A
MATCH (n1)-[oldEdge:COMMON]->(n2)
WHERE n1.musician_id = '50'
WITH n1, n2, oldEdge,
REDUCE(acc = 0, i IN RANGE(0, 40) | acc + A[i] * oldEdge.vector[i]) AS dotProduct
WHERE dotProduct > 0
CREATE (n1)-[:NEW_EDGE {dotProduct: dotProduct}]->(n2);

//View frequency edges
Match (n1:new) -[r:NEW_EDGE] -> (n2:new)
where n1.musician_id = '50'
return n1, r, n2


//Use this to delete NEW_EDGES and start investigating another node
Match (n1) -[r:NEW_EDGE] -> (n2)
delete r
