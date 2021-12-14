using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class giraRobot : MonoBehaviour
{

    Vector3[] points;
    float angle;

    void TransformRobot() {
        
        int n = points.Length;
        Vector4[] vs = new Vector4[n];
        Vector3[] final = new Vector3[n];

        for(int i = 0; i < n; i++) {
            vs[i] = points[i];
            vs[i].w = 1.0f;
        }

        Matrix4x4 MR = RotateY(angle);

        for(int i = 0; i < n; i++) {
            Vector4 hom = new Vector4(points[i].x, points[i].y, points[i].z, 1);
            vs[i] = MR * hom;
            final[i] = vs[i];
        }

        GetComponent<MeshFilter>().mesh.vertices = final;

    }


    // Start is called before the first frame update
    void Start()
    {
        angle = 0;
        Mesh mesh = GetComponent<MeshFilter>().mesh;
        points = mesh.vertices;
    }

    // Update is called once per frame
    void Update()
    {
        // angle -= 1.0f;
        // TransformRobot();

    }

    static Matrix4x4 RotateY(float ra)
    {
        Matrix4x4 rm = Matrix4x4.identity;
        rm[0, 0] = Mathf.Cos(ra * Mathf.Deg2Rad);
        rm[0, 2] = Mathf.Sin(ra * Mathf.Deg2Rad);
        rm[2, 0] = -Mathf.Sin(ra * Mathf.Deg2Rad);
        rm[2, 2] = Mathf.Cos(ra * Mathf.Deg2Rad);
        
        return rm;
    }
}
