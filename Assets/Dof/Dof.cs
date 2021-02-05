using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dof : MonoBehaviour
{
    public Material dofMat;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination);

    }


}
