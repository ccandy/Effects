using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class BloomScripts : MonoBehaviour
{
    private int _width, _height;
    private RenderTextureFormat _format;
    [Range(1, 16)]
    public int iterations = 1;


    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        _width = source.width;
        _height = source.height;
        _format = source.format;
        RenderTexture _currentSource = source;

        for(int n = 0; n < iterations; n++) 
        {

            _width /= 2;
            _height /= 2;
            if (_height / 2 < 0)
            {
                break;
            }

            RenderTexture _currentDes = RenderTexture.GetTemporary(_width, _height, 0, _format);
            Graphics.Blit(_currentSource, _currentDes);
            _currentSource = _currentDes;
            RenderTexture.ReleaseTemporary(_currentDes);
        }
        Graphics.Blit(_currentSource, destination);
        RenderTexture.ReleaseTemporary(_currentSource);
    }
}
