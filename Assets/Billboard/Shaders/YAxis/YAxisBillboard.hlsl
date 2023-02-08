void Billboard_float(float4 positionOS, out float4 positionHCS)
{
    // Y-UPベクトル
    float3 yup = float3(0.0, 1.0, 0.0);

    // up = Y軸の基底ベクトル
    // オブジェクトのTransformの回転を考慮
    float3 up = mul((float3x3)unity_ObjectToWorld, yup);

    // オブジェクトのワールド座標
    float3 worldPos = unity_ObjectToWorld._m03_m13_m23;

    // オブジェクトからカメラに向かうベクトル
    float3 toCamera = _WorldSpaceCameraPos - worldPos;

    // right = X軸の基底ベクトル
    // 前半の項 : rightはtoCameraとupの両方に直交するので、crossから計算
    // 後半の項 : オブジェクトのTransformのX方向のスケールを考慮
    float3 right = normalize(cross(toCamera, up)) * length(unity_ObjectToWorld._m00_m10_m20);

    // forward = Z軸の基底ベクトル
    // 前半の項 : forwardはupとrightの両方に直交するので、crossから計算
    // 後半の項 : オブジェクトのTransformのZ方向のスケールを考慮
    // float3 forward = normalize(cross(up, right)) * length(unity_ObjectToWorld._m02_m12_m22);
    float3 forward = normalize(cross(up, right)) * length(unity_ObjectToWorld._m02_m12_m22);

    // 各基底ベクトルを並べてビルボード用の回転行列を生成
    // （厳密には平行移動とスケールも含んだ変換行列）
    float4x4 mat = {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1,
    };

    mat._m00_m10_m20 = right;//     X軸の基底ベクトル
    mat._m01_m11_m21 = up;//        Y軸の基底ベクトル
    mat._m02_m12_m22 = forward;//   Z軸の基底ベクトル
    mat._m03_m13_m23 = worldPos;//  平行移動のベクトル

    // ローカル座標（平行移動のためにw=1）
    float4 vertex = float4(positionOS.xyz, 1);

    // ビルボード用の回転行列を乗算してワールド空間に変換
    vertex = mul(mat, vertex);
    positionHCS = vertex;
}