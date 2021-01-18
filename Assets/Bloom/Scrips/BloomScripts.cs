using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class BloomScripts : MonoBehaviour
{
    private int _width, _height;
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        _width = source.width;
        _height = source.height;

        _width /= 2;
        _height /= 2;
        RenderTexture rt = RenderTexture.GetTemporary(_width, _height, 0, source.format);

        Graphics.Blit(source, rt);
        Graphics.Blit(rt, destination);

        RenderTexture.ReleaseTemporary(rt);


    }
}
