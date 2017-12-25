using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PointCloudGenerator : MonoBehaviour {
    public Mesh originalMesh;
    public MeshTopology topology;
    Mesh m;
    MeshRenderer mr;
    public Material material;
    int[] indices;
	// Use this for initialization
	void OnEnable () {
        if (originalMesh == null)
            return;

        m = new Mesh();
        m.vertices = originalMesh.vertices;
        m.triangles = originalMesh.triangles;
        indices = new int[m.vertices.Length];
        for(int i = 0;i< indices.Length;i++)
        {
            indices[i] = i;
        }
        m.SetIndices(originalMesh.GetIndices(0), topology, 0);
        mr = gameObject.AddComponent<MeshRenderer>();
        
        mr.hideFlags = HideFlags.HideAndDontSave;
        MeshFilter mf = gameObject.AddComponent<MeshFilter>();
        mf.hideFlags = HideFlags.HideAndDontSave;

        mf.sharedMesh = m;
        mr.sharedMaterial = material;
    }

    private void OnDisable()
    {
        if (!Application.isPlaying)
        {
            DestroyImmediate(mr);
            DestroyImmediate(GetComponent<MeshFilter>());
        }else
        {
            Destroy(mr);
            Destroy(GetComponent<MeshFilter>());
        }
    }

    // Update is called once per frame
    void Update () {
		
	}

    private void OnDrawGizmos()
    {
        /*
        for (int i = 0; i < m.vertexCount; i++)
        {
            Gizmos.DrawSphere(m.vertices[i], 0.1f);
        }
        */
    }
}
