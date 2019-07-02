"""
3D and 4D niimgs: handling and visualizing
==========================================

Here we discover how to work with 3D and 4D niimgs.
"""
import sys
import nilearn

if(len(sys.argv) > 1):
    mode=sys.argv[1]
else:
    mode='no-sgx'
idx=0;

###############################################################################
# Downloading tutorial datasets from Internet
# --------------------------------------------
#
# Nilearn comes with functions that download public data from Internet
#
# Let's first check where the data is downloaded on our disk:
from nilearn import datasets, image, plotting
from nilearn.datasets.utils import _get_dataset_dir, _fetch_files, _get_dataset_descr
from nilearn._utils.compat import _basestring
from sklearn.datasets.base import Bunch

def load_atlas_smith():
    dataset_name = '/iexec_in/smith_2009'

    files = [
          #  'rsn20.nii.gz',
          #  'PNAS_Smith09_rsn10.nii.gz',
          #  'rsn70.nii.gz',
            'bm20.nii.gz'
          #  'PNAS_Smith09_bm10.nii.gz',
          #  'bm70.nii.gz'
    ]

    files = [dataset_name + '/' + f for f in files]

    fdescr = _get_dataset_descr(dataset_name)

    keys = ['bm20'] #['rsn20', 'rsn10', 'rsn70', 'bm20', 'bm10', 'bm70']
    params = dict(zip(keys, files))
    params['description'] = fdescr

    return Bunch(**params)

if mode is 'no-sgx':

    print('Datasets are stored in: %r' % datasets.get_data_dirs())

    ###############################################################################
    # Let's now retrieve a motor contrast from a Neurovault repository
    motor_images = datasets.fetch_neurovault_motor_task()
    print(motor_images.images)

    ###############################################################################
    # motor_images is a list of filenames. We need to take the first one
    tmap_filename = motor_images.images[0]

    print(tmap_filename)

    display = plotting.plot_stat_map(tmap_filename)
    idx+=1
    display.savefig(dir + '/' + prefix + str(idx))

    ###############################################################################
    # Visualizing works better with a threshold
    display = plotting.plot_stat_map(tmap_filename, threshold=3)
    idx+=1
    display.savefig(dir+'/'+prefix+str(idx))

elif mode == 'sgx':
    atlas = load_atlas_smith()
    keys = ['bm20']
    for key in keys:
        for img in image.iter_img(atlas[key]):
            # img is now an in-memory 3D img
            idx+=1
            display = plotting.plot_stat_map(img, threshold=3, display_mode="z", cut_coords=1,
                                   colorbar=False)
            display.savefig('/scone/image_' + str(idx))


###############################################################################
# plotting.show is useful to force the display of figures when running
# outside IPython
#plotting.show()

#########################################################################
# |
#
# ______
#
# To recap, neuroimaging images (niimgs as we call them) come in
# different flavors:
#
# * 3D images, containing only one brain volume
# * 4D images, containing multiple brain volumes.
#
# More details about the input formats in nilearn for 3D and 4D images is
# given in the documentation section: :ref:`loading_data`.
#
# Functions accept either 3D or 4D images, and we need to use on the one
# hand :func:`nilearn.image.index_img` or :func:`nilearn.image.iter_img`
# to break down 4D images into 3D images, and on the other hand
# :func:`nilearn.image.concat_imgs` to group a list of 3D images into a 4D
# image.
