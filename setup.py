__author__ = 'jason'
from setuptools import setup

install_requires = [
    'cloudify-plugins-common==3.2a8',
    'pika==0.9.13',
    'proxy_tools==0.1.0',
    'bottle==0.12.7'
]

try:
    import importlib    # noqa
except ImportError:
    install_requires.append('importlib')

try:
    import argparse  # NOQA
except ImportError, e:
    install_requires.append('argparse==1.2.2')

setup(
    name='cloudify-cloudfoundry-plugin',
    version='3.2a8',
    author='cosmo-admin',
    author_email='cosmo-admin@gigaspaces.com',
    packages=['cloudfoundry'],
    license='LICENSE',
    description='Contains necessary decorators and utility methods for '
                'writing Cloudify plugins',
    zip_safe=False,
    install_requires=install_requires,
    entry_points={
        'console_scripts': [
            'ctx = cloudify.proxy.client:main',
        ]
    }
)
