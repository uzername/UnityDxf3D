using System;
using UnityEngine;
using UnityEngine.InputSystem;
/// <summary>
/// https://www.youtube.com/watch?v=PM8BZK3ig2s - how to orbit
/// https://www.youtube.com/watch?v=qEpmOqLHWcA - how to pan and zoom
/// https://assetstore.unity.com/packages/tools/camera/camera-orbit-44146 - paid alternative
/// </summary>
public class CameraController : MonoBehaviour
{
    float rotationSpeed = 300.0f;
    private Vector3 mouseWorldPosStart;
    private float zoomScale = 10.0f;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.Mouse1))
        {
            CamOrbit();
        }
        if (Input.GetMouseButtonDown(2))
        {
            mouseWorldPosStart = GetPerspectivePos();
        }
        if (Input.GetMouseButton(2))
        {
            Pan();
        }
        Zoom(Input.GetAxis("Mouse ScrollWheel"));
    }

    private void Zoom(float zoomDiff)
    {
        bool moveCameraHolderInsteadOfCamera = false;
        if (zoomDiff!=0)  {
            Debug.Log(zoomDiff);
            Transform t = Camera.main.transform; 
            Vector3 look = t.TransformDirection(Vector3.forward);
            if (moveCameraHolderInsteadOfCamera)  {
                transform.position += look.normalized * zoomScale * zoomDiff;
            } else  {
                Camera.main.transform.position += look.normalized * zoomScale * zoomDiff;
            }
        }
    }

    private void Pan()
    {
        if ((Input.GetAxis("Mouse Y")!=0) || (Input.GetAxis("Mouse X") != 0))
        {
            Vector3 mouseWorldPosDiff = mouseWorldPosStart - GetPerspectivePos();
            transform.position += mouseWorldPosDiff;
        }
    }
    public void FitToScreen()
    {
        //Camera.main.fieldOfView = defaultFieldOfView;
        //Bounds bound = GetBound(parentModel);
        //Vector3 boundSize = bound.size;
        //float boundDiagonal = Mathf.Sqrt((boundSize.x * boundSize.x) + (boundSize.y * boundSize.y) + (boundSize.z * boundSize.z));
        //float camDistanceToBoundCentre = boundDiagonal/2.0f/(Mathf.Tan(Camera.main.fieldOfView / 2.0f * Mathf.Deg2Rad));
        //float camDistanceToBoundWithOffset = camDistanceToBoundCentre + boundDiagonal/2.0f - (Camera.main.transform.position - transform.position).magnitude;
        //transform.position = bound.center + (-transform.forward + camDistanceToBoundWithOffset);
    }
    public Vector3 GetPerspectivePos()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        Plane plane = new Plane(transform.forward, 0.0f);
        float dist;
        plane.Raycast(ray, out dist);
        return ray.GetPoint(dist);
    }
    private void CamOrbit()
    {
        if ((Input.GetAxis("Mouse X") != 0) || (Input.GetAxis("Mouse Y") != 0))  {
            float verticalInput = Input.GetAxis("Mouse Y") * rotationSpeed * Time.deltaTime;
            float horizontalInput = Input.GetAxis("Mouse X") * rotationSpeed * Time.deltaTime;
            transform.Rotate(Vector3.right, verticalInput);
            transform.Rotate(Vector3.up, horizontalInput, Space.World);
        }
    }
}
