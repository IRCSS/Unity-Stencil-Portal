using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CatLookAtManager : MonoBehaviour
{


    public GameObject catBody;
    private Camera main_Cam;

    private Material m;

    // Start is called before the first frame update
    void Start()
    {
        main_Cam = Camera.main;

        m= catBody.GetComponent<Renderer>().sharedMaterial;

    }

    // Update is called once per frame
    void Update()
    {

        Vector3 lookAtVector =  (this.transform.worldToLocalMatrix *main_Cam.transform.position).normalized;
        Vector3 coordinateRight = Vector3.Cross(Vector3.up, lookAtVector).normalized;
        Vector3 coordUp = Vector3.Cross(lookAtVector, coordinateRight);

        Matrix4x4 lookAtMatrix = new Matrix4x4( coordinateRight, coordUp, lookAtVector, new Vector4(0.0f, 0.0f, 0.0f, 1.0f));

        Matrix4x4 objectToClip = GL.GetGPUProjectionMatrix(main_Cam.projectionMatrix, true)
                               * main_Cam.worldToCameraMatrix * this.transform.localToWorldMatrix
                               * lookAtMatrix * this.transform.worldToLocalMatrix;

        m.SetMatrix("_LookAtToClipPos", objectToClip);
        m.SetVector("_Pivot", transform.position);


    }
}
