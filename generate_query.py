import numpy as np

def calculate_mask(start, end):
    A = np.zeros(41)
    A[start:end+1] = 1

    str_arr = '['

    for entry in A:
        str_arr += f'{int(entry)},'

    str_arr = str_arr[:-1]
    str_arr += ']'
    return str_arr


if __name__ == "__main__":
    A = int(input("start year\n")) - 1929
    B = int(input("end year\n")) - 1929

    mask = calculate_mask(A,B)

    cypher_query = f'''
    WITH {mask} AS A
    MATCH (n1:Musician)-[oldEdge:COMMON]->(n2:Musician)
    WITH n1, n2, oldEdge,
      REDUCE(acc = 0, i IN RANGE(0, 40) | acc + A[i] * oldEdge.vector[i]) AS dotProduct
    WHERE dotProduct > 0
    CREATE (n1)-[:NEW_EDGE {{dotProduct: dotProduct}}]->(n2);
    '''


    print(cypher_query)
