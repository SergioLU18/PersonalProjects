using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class collide : MonoBehaviour
{
    void OnCollisionEnter(Collision col) {
        if(col.gameObject.tag == "Estante") {
            gameObject.SetActive(false);
        }
    }
}
