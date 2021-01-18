using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class BloomScripts : MonoBehaviour
{
    private int _width, _height;
    private RenderTextureFormat _format;
    //private RenderTexture[] _renderTextures = new RenderTexture[16];
    [Range(1, 16)]
    public int iterations = 1;

    public Material BloomMat;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if(BloomMat == null)
        {
            Debug.LogError("Bloom Mat is Null");
            return;
        }

        _width = source.width;
        _height = source.height;
        _format = source.format;
        RenderTexture _currentSource = source;
        

        for(int n = 0; n < iterations; n++) 
        {

            _width /= 2;
            _height /= 2;
            if (_height / 2 < 1)
            {
                return;
            }

            RenderTexture _currentDes = RenderTexture.GetTemporary(_width, _height, 0, _format);
            //_renderTextures[n] = _currentDes;
            Graphics.Blit(_currentSource, _currentDes, BloomMat);
            _currentSource = _currentDes;
            RenderTexture.ReleaseTemporary(_currentDes);
        }
        BloomMat.SetTexture("_SourceTex", source);

        Graphics.Blit(_currentSource, destination, BloomMat,1);
        RenderTexture.ReleaseTemporary(_currentSource);
    }
}
