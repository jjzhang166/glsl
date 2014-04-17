#ifdef GL_ES
precision mediump float;
#endif
	                                    
uniform sampler2D g_texture0;
uniform sampler2D g_texture1;

varying vec2 v_uv;
                    
void main()
{
	vec2 decalOffset = vec2(0.0, 0.0);
	vec2 decalRange = vec2(1.0, 1.0);

	vec4 vDiffuse = texture2D(g_texture0, v_uv);
	vec2 mappedUV = (v_uv - decalOffset) / decalRange;
	vec4 vDecal = texture2D(g_texture1, mappedUV);

	bvec2 smaller = lessThan(mappedUV, vec2(0.0, 0.0));
	bvec2 greater = greaterThan(mappedUV, vec2(0.0, 0.0));
	float fRatio = any(smaller) || any(greater) ? 0.0 : vDecal.a;
	
	gl_FragColor = mix(vDiffuse, vDecal, fRatio);
}