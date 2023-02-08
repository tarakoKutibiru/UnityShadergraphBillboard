using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour {
    [SerializeField] float rotateSpeed = 1.0f;

    void Update()
    {
        var y = Input.GetAxis("Horizontal") * rotateSpeed;
        transform.RotateAround(Vector3.zero, Vector3.up, y);

        var x = Input.GetAxis("Vertical") * rotateSpeed;
        transform.RotateAround(Vector3.zero, this.transform.right, x);
    }
}