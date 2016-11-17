using UnityEngine;
using System.Collections;
using UnityEngine.Rendering;

public class OutlineRenderer : MonoBehaviour {
	
	[SerializeField] private Material outlineMaterial;
	[SerializeField] private Material blurMaterial;
	[SerializeField] private Renderer[] outlineRenderers;

	[Header("Outline Settings")]
	[Range(0, 1)]
	[SerializeField] private float OutlineSize = 0.005f;
	[Range(0, 1)]
	[SerializeField] private float BlurAmount = 0.003f;
	[SerializeField] private Color OutlineColor = Color.white;

	public CommandBuffer commandBuffer;
	public RenderTexture renderTextureOutline;
	public RenderTexture renderTextureOutlineBlur;
	public RenderTargetIdentifier renderTargetIdentifier;

	private void Awake() {
		CreateCommandBuffer ();
	}

	private void OnRenderImage( RenderTexture source, RenderTexture destination ) {
		outlineMaterial.SetFloat ("_Size", OutlineSize);
		blurMaterial.SetFloat ("_BlurAmount", BlurAmount);
		outlineMaterial.SetColor ("_OutlineColor", OutlineColor);

		RenderTexture.active = renderTextureOutline;
		GL.Clear (true, true, Color.clear);
		RenderTexture.active = null;

		commandBuffer.Clear ();

		renderTargetIdentifier = new RenderTargetIdentifier (renderTextureOutline);
		commandBuffer.SetRenderTarget (renderTargetIdentifier);

		for (int i = 0; i < outlineRenderers.Length; i++) {
			commandBuffer.DrawRenderer (outlineRenderers[i], outlineMaterial, 0, 0);
		}
		for (int i = 0; i < outlineRenderers.Length; i++) {
			commandBuffer.DrawRenderer (outlineRenderers[i], outlineMaterial, 0, 1);
		}

		RenderTexture.active = renderTextureOutline;
		Graphics.ExecuteCommandBuffer (commandBuffer);
		RenderTexture.active = null;

		Graphics.Blit (renderTextureOutline, renderTextureOutlineBlur, blurMaterial, -1);
		outlineMaterial.SetTexture ("_OutlineTex", renderTextureOutlineBlur);
		Graphics.Blit (source, destination, outlineMaterial, 2);
	}

	public void CreateCommandBuffer() {
		renderTextureOutline = new RenderTexture (Screen.width, Screen.height, 0);
		renderTextureOutlineBlur = new RenderTexture (Screen.width, Screen.height, 0);

		renderTargetIdentifier = new RenderTargetIdentifier (renderTextureOutline);

		commandBuffer = new CommandBuffer ();
		commandBuffer.name = "OutlineRenderer";
	}

	public void RenderOutline() {
		
	}

}
