using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ghost : MonoBehaviour
{

    public float frequency;


    private float timer;

    private Material m;

    private int index = 0;
    // Start is called before the first frame update
    void Start()
    {
        Renderer r = gameObject.GetComponent<Renderer>();
        

        MeshFilter mf = gameObject.GetComponent<MeshFilter>();
        mf.sharedMesh.bounds = new Bounds(Vector3.zero, new Vector3(1000.0f, 10000.0f, 1000.0f)); ;


        m =r.material;
        float seed = Random.Range(1.0f, 500.0f);
        m.SetFloat("_RandomSeed", seed);
   
        timer = Random.Range(0.0f, 1.0f/ frequency);
    }

    private void OnDestroy()
    {
        Destroy(m);
    }

    // Update is called once per frame
    void Update()
    {
        timer += Time.deltaTime;
        if(timer >= 1.0f / frequency)
        {
            float x = Random.Range(-80.0f, 80.0f);
            float y = Random.Range(-15.0f, 15.0f);
            this.transform.forward =  Quaternion.Euler(new Vector3(x, 0.0f , y)) * Vector3.up;

            float scale = Random.Range(50f, 100f);
            this.transform.localScale = new Vector3(scale, scale, scale);
            timer = 0.0f;

            index++;
        }

        m.SetFloat("_timer", timer* frequency);
        m.SetFloat("_RunIndex", index);
    }
}
