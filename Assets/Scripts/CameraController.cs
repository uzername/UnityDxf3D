using UnityEngine;
using UnityEngine.InputSystem;
/// <summary>
/// https://www.youtube.com/watch?v=PM8BZK3ig2s - how to orbit
/// https://www.youtube.com/watch?v=qEpmOqLHWcA - how to pan and zoom
/// </summary>
public class CameraController : MonoBehaviour
{
    float rotationSpeed = 300.0f;
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
