using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dof : MonoBehaviour
{
    public Material dofMat;
    private Camera mCamera;
    const int CocPass = 0;

    private void Start()
    {
        mCamera = gameObject.GetComponent<Camera>();
        //设置Camera的depthTextureMode,使得摄像机能生成深度图。
        if (mCamera)
        {
            mCamera.depthTextureMode = DepthTextureMode.Depth;
        }
    }

    void OnEnable()
    {
        gameObject.GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, dofMat,CocPass);

    }



}
