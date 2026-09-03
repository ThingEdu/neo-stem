#!/usr/bin/env python3
"""Nạp thử từng file QML của mọi hoạt động, báo lỗi nếu file nào không nạp được.

Vì sao cần: NEO STEM nạp QML lúc chạy chứ không biên dịch trước, nên một lỗi
QML (ví dụ viết onXxxChanged cho thuộc tính khai báo ở phần tử cha) vẫn cho
đóng gói .deb thành công và cài lên máy bình thường — chỉ tới khi học sinh bấm
vào bài mới thấy màn hình trống. Bản v1.0.3 đã phát hành kèm đúng hai lỗi kiểu
đó ở bài 13 bước 1 và bài 11 bước 3.

Phải chạy bằng PyQt6 trong venv của dự án, KHÔNG dùng Qt6 hệ thống — đó là sai
stack và có thể bỏ sót khác biệt phiên bản.

    python3 -m venv .venv && .venv/bin/pip install PyQt6
    QT_QPA_PLATFORM=offscreen .venv/bin/python scripts/check_qml_loads.py

Trả về mã thoát khác 0 nếu có file không nạp được, để dùng trực tiếp trong CI.
"""

import pathlib
import sys

from PyQt6.QtCore import QUrl
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlComponent, QQmlEngine

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
QML_DIR = REPO_ROOT / "neo_stem" / "qml"


def build_engine() -> QQmlEngine:
    """Dựng engine với đúng các đường import mà neo_stem/app.py dùng."""
    engine = QQmlEngine()
    engine.addImportPath(str(QML_DIR))
    engine.addImportPath(str(QML_DIR / "core"))
    engine.addImportPath(str(QML_DIR / "menu"))
    for activity_dir in sorted((QML_DIR / "activities").iterdir()):
        if activity_dir.is_dir():
            engine.addImportPath(str(activity_dir))
    return engine


def main() -> int:
    # Phải giữ tham chiếu tới app: nếu để nó bị thu hồi thì QQmlEngine dựng sau
    # sẽ báo "Must construct a QCoreApplication before a QJSEngine".
    app = QGuiApplication(sys.argv)
    assert app is not None
    engine = build_engine()

    failures = []
    total = 0
    for activity_dir in sorted((QML_DIR / "activities").iterdir()):
        if not activity_dir.is_dir():
            continue
        for qml_file in sorted(activity_dir.glob("*.qml")):
            if qml_file.name == "qmldir":
                continue
            total += 1
            component = QQmlComponent(engine, QUrl.fromLocalFile(str(qml_file)))
            if component.isError():
                failures.append((qml_file, component.errors()))

    for qml_file, errors in failures:
        rel = qml_file.relative_to(REPO_ROOT)
        print(f"LỖI NẠP: {rel}")
        for error in errors:
            print(f"    {error.toString()}")

    ok = total - len(failures)
    print(f"\n{ok}/{total} file QML nạp được.")
    if failures:
        print(f"{len(failures)} file KHÔNG nạp được — người dùng sẽ thấy màn hình trống.")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
